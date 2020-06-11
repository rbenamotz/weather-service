import { Body, Controller, Get, Header, NotFoundException, Param, Post, UseGuards, HttpService, Injectable } from '@nestjs/common';
import { response } from 'express';
import { Observable } from 'rxjs';
import { AxiosResponse } from "axios";
import { SecretService } from 'awsSecret.service';

@Controller()
@Injectable()
export class WeatherController {
    constructor(private readonly http: HttpService, private readonly secretService: SecretService) { }


    @Get('/weather/:zipcode')
    @Header('content-type', 'application/json')
    async getWeatherForZip(@Param() params) {
        const apiKey = await this.secretService.getSecretValue('openweathermap-api-dev-key');
        const urlParams = { zip: params.zipcode + ',us', appid: apiKey }
        const url = 'http://api.openweathermap.org/data/2.5/weather'; 
        const response = await this.http.get(url, {params: urlParams}).toPromise();
        return response.data;
    }



    @Get('/weather')
    async getRoot(): Promise<string> {
        return 'Weather service is up and running. Work SMARTER not harder ';
    }

}
