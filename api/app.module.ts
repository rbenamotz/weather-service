import { Module, HttpModule } from '@nestjs/common';
import { AppService } from './service/app.service';
import { HealthController } from 'controller/health.controller';
import { WeatherController } from 'controller/weather.controller';
import { SecretService } from 'service/awsSecret.service';
import { WinstonModule } from 'nest-winston';
import winston = require('winston');

@Module({
  imports: [
    WinstonModule.forRoot({
      level: 'debug',
      format: winston.format.json(),
      transports: [
        new winston.transports.Console()
      ]
    }),
    HttpModule
  ],
  controllers: [HealthController, WeatherController],
  providers: [AppService, SecretService],
})
export class AppModule { }
