import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import AWS = require('aws-sdk');

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(3000);
}


var proxy = require('proxy-agent');
AWS.config.update({
  httpOptions: { agent: proxy('http://genproxy.corp.amdocs.com:8080') }
});
bootstrap();
