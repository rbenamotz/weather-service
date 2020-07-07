import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import AWS = require('aws-sdk');

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(3000);
}
require('dotenv').config()

AWS.config.update({ region: process.env.AWS_REGION });
// var proxy = require('proxy-agent');9
// AWS.config.update({
//   httpOptions: { agent: proxy('http://genproxy.corp.amdocs.com:8080') }
// });
bootstrap();

