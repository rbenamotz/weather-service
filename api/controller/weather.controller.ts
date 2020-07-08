import { Controller, Get, Header, Param, HttpService, Injectable } from '@nestjs/common';
import { SecretService } from 'service/awsSecret.service';
import AWS = require('aws-sdk');
import { response } from 'express';

@Controller()
@Injectable()
export class WeatherController {
    constructor(private readonly http: HttpService, private readonly secretService: SecretService) { }

    async sendToQ(body: { zip: any; temp: any; }) {
        var sqs = new AWS.SQS({ apiVersion: '2012-11-05' });
        var params = {
            MessageBody: JSON.stringify(body),
            QueueUrl: process.env.QUEUE_URL,
        };
        console.log("sendToQ " + JSON.stringify(body));
        return sqs.sendMessage(params, err => {
            if (err) throw err;
            else console.log("Sent to log")
        }).promise();
    }



    @Get('/weather/:zipcode')
    @Header('content-type', 'application/json')
    async getWeatherForZip(@Param() params) {
        const apiKey = await this.secretService.getSecretValue(process.env.OPENWEATHERMAP_KEY);
        const urlParams = { zip: params.zipcode + ',us', appid: apiKey }
        const url = process.env.WEATHER_SRV_URL;
        let p = this.http.get(url, { params: urlParams }).toPromise();
        return p
            .then(result => { return (result.data) })
        // .catch(failureCallback);
        // p = p.then(response => {
        //     return response.data;

        // });
        // p = p.then(data => {
        //     var msg = {
        //         zip: params.zipcode,
        //         temp: data['main']['temp']
        //     }
        //     return msg;
        // })
        // return p;
        // var promise = this.sendToQ(msg);
        // promise = promise.then(() => { return response.data });
        // return promise;
        // return response.data;

    }



    @Get('/weather')
    async getRoot(): Promise<string> {
        return 'Weather service is up and running. Work SMARTER not harder ';
    }

}
