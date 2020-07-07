import { Module, HttpModule } from '@nestjs/common';
import { AppService } from './service/app.service';
import { HealthController } from 'controller/health.controller';
import { WeatherController } from 'controller/weather.controller';
import { SecretService } from 'service/awsSecret.service';

@Module({
  imports: [HttpModule],
  controllers: [HealthController, WeatherController],
  providers: [AppService, SecretService],
})
export class AppModule { }
