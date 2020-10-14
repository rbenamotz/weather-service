echo "Cleanup"
call rimraf ./dist
call rimraf ./dist-layers
echo "Building"
call nest build

@REM bundle:prepare 
if not exist dist-layers\nodejs mkdir dist-layers\nodejs
if not exist dist mkdir dist
xcopy config dist\ /s /e
copy package.json .\dist-layers\nodejs\ /Y
copy package-lock.json .\dist-layers\nodejs\ /Y
cd dist-layers\nodejs
call npm install --only=prod
call rimraf ./node_modules/aws-sdk
cd ..\..\

@REM Archive
echo "Zipping dist"
cd dist\ 
call zip -qr build.zip .
cd ..\
echo "Zipping layers"
cd dist-layers
call zip -qr layers.zip .
cd ..\

echo "Done"
REM call npm run bundle:prepare
    REM npm run bundle:archive:app
    REM npm run bundle:archive:layers
    REM # "bundle:prepare": "mkdir -p dist-layers/nodejs && mkdir -p dist && cp -r config dist/config && cp package.json ./dist-layers/nodejs/ && cp package-lock.json ./dist-layers/nodejs/ && cd dist-layers/nodejs && npm install --only=prod && rimraf ./node_modules/aws-sdk",
    REM # "bundle:archive:app": "cd dist/ && zip -qr build.zip .",
    REM # "bundle:archive:layers": "cd dist-layers && zip -qr layers.zip .",
