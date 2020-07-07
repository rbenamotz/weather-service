import { NestFactory } from '@nestjs/core';
import { ExpressAdapter } from '@nestjs/platform-express';
import { Context } from 'aws-lambda';
import { createServer, proxy } from 'aws-serverless-express';
import * as express from 'express';
import * as http from 'http';
import { Server } from 'http';
import { AppModule } from './app.module';
import { Logger } from '@nestjs/common';

let cachedServer: Server;

async function bootstrapServer(): Promise<Server> {
    try {
        const expressApp = express();
        const adapter = new ExpressAdapter(expressApp);
        const app = await NestFactory.create(AppModule, adapter);
        app.use(express.json({ limit: '5mb' }));
        app.enableCors();
        await app.init();
        return createServer(expressApp);
    } catch (error) {
        Logger.error('Error during init', error);
        throw error;
    }
}

function bootstrapHandler(
    event,
    context: Context,
): http.Server {

    if (cachedServer) {
        return proxy(cachedServer, event, context);
    }
    bootstrapServer().then(server => {
        cachedServer = server;
        return proxy(server, event, context);
    });
}

export const handler = bootstrapHandler;
