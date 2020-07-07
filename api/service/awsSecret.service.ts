import {Injectable} from '@nestjs/common';
import {SecretsManager} from 'aws-sdk';

@Injectable()
export class SecretService {
    private secretsManager: SecretsManager;
    private store = new Map<string, any>();

    constructor() {
        this.secretsManager = new SecretsManager();
    }

    public async getSecretValue(key: string) {
        const cachedValue = this.store.get(key);
        if (cachedValue) {
            return cachedValue;
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
