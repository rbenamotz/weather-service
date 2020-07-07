import { Body, Controller, Get, Header, NotFoundException, Param, Post, UseGuards, HttpService, Injectable } from '@nestjs/common';
import { response } from 'express';
import { Observable } from 'rxjs';
import { AxiosResponse } from "axios";
import { SecretService } from 'awsSecret.service';
import AWS = require('aws-sdk');

@Controller()
@Injectable()
export class WeatherController {
    constructor(private readonly http: HttpService, private readonly secretService: SecretService) { }

    async sendToQ() {
        var sqs = new AWS.SQS({ apiVersion: '2012-11-05' });
        var params = {
            MessageBody: 'STRING_VALUE',
            QueueUrl: 'https://sqs.us-east-1.amazonaws.com/192158051712/com-benamotz-dev-weather-queue',
        };
        return sqs.sendMessage(params, function (err, data) {
            if (err) console.log(err, err.stack); // an error occurred
            else console.log(data);           // successful response
        }).promise();
    }



    @Get('/weather/:zipcode')
    @Header('content-type', 'application/json')
    async getWeatherForZip(@Param() params) {
        const apiKey = await this.secretService.getSecretValue('openweathermap-api-dev-key');
        const urlParams = { zip: params.zipcode + ',us', appid: apiKey }
        const url = 'http://api.openweathermap.org/data/2.5/weather';
        const response = await this.http.get(url, { params: urlParams }).toPromise();
        return this.sendToQ().then(() => {
            return response.data;
        });
    }



    @Get('/weather')
    async getRoot(): Promise<string> {
        return 'Weather service is up and running. Work SMARTER not harder ';
    }

}
