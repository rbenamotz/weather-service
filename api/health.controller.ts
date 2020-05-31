import {Controller, Get} from '@nestjs/common';

@Controller()
export class HealthController {

    @Get('/health')
    async getRoot(): Promise<string> {
        return 'Weather service is up and running ';
    }

}
