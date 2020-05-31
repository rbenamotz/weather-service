import { Module, HttpModule } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { HealthController } from 'health.controller';
import { WeatherController } from 'weather.controller';
import { SecretService } from 'awsSecret.service';

@Module({
  imports: [HttpModule],
  controllers: [AppController, HealthController ,WeatherController],
  providers: [AppService, SecretService],
})
export class AppModule {}
