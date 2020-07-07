import { Body, Controller, Get, Header, NotFoundException, Param, Post, UseGuards, HttpService, Injectable } from '@nestjs/common';
import { response } from 'express';
import { Observable } from 'rxjs';
import { AxiosResponse } from "axios";
import { SecretService } from 'service/awsSecret.service';
import AWS = require('aws-sdk');

@Controller()
@Injectable()
export class WeatherController {
    constructor(private readonly http: HttpService, private readonly secretService: SecretService) { }

    async sendToQ(body) {
        var sqs = new AWS.SQS({ apiVersion: '2012-11-05' });
        var params = {
            MessageBody: JSON.stringify(body),
            QueueUrl: process.env.QUEUE_URL,
        };
        return sqs.sendMessage(params, function (err, data) {
            if (err) {
                console.log(err, err.stack);
                throw err;
            }
        });
    }



    @Get('/weather/:zipcode')
    @Header('content-type', 'application/json')
    async getWeatherForZip(@Param() params) {
        const apiKey = await this.secretService.getSecretValue(process.env.OPENWEATHERMAP_KEY);
        const urlParams = { zip: params.zipcode + ',us', appid: apiKey }
        const url = process.env.WEATHER_SRV_URL;
        const response = await this.http.get(url, { params: urlParams }).toPromise();
        var msg = {
            zip: params.zipcode,
            temp: response.data.main.temp
        }
        await this.sendToQ(msg);
        return response.data;
    }



    @Get('/weather')
    async getRoot(): Promise<string> {
        return 'Weather service is up and running. Work SMARTER not harder ';
    }

}
