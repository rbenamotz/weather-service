import {Injectable} from '@nestjs/common';
import {SecretsManager} from 'aws-sdk';

@Injectable()
export class SecretService {
    private secretsManager: SecretsManager;
    private store = new Map<string, any>();

    constructor() {
        this.secretsManager = new SecretsManager({
            region: 'us-east-1',
        });
    }

    public async getSecretValue(key: string) {
        const temp = this.store.get(key);
        if (temp) {
            return temp;
        }
        const response = await this.secretsManager
            .getSecretValue({SecretId: key})
            .promise();
        if (!response.SecretString) {
            throw new Error('secret is not available');
        }
        const result = response.SecretString;
        this.store.set(key, result);
        return result;
    }

}
