# LT-Detox
Run your Detox tests on LambdaTest Real Device Cloud Platform using HyperExecute.

## Prerequisites
1. Clone this repository
2. Ensure you have the following installed:
   - Node.js 18 (required)
   - npm (comes with Node.js)
   - React Native development environment
   - [HyperExecute CLI](https://www.lambdatest.com/hyperexecute)

## Setting up the Environment

### 1. Install Node.js 18 using nvm
```bash
# Install nvm if you haven't already
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install and use Node.js 18
nvm install 18
nvm use 18
```

### 2. Set LambdaTest Credentials
Export your LambdaTest credentials. You can get these from your [LambdaTest Profile](https://accounts.lambdatest.com/detail/profile)

```bash
export LT_USERNAME="your_username"
export LT_ACCESS_KEY="your_access_key"
```

### 3. Download HyperExecute CLI

#### For Mac:
```bash
curl -O https://downloads.lambdatest.com/hyperexecute/darwin/hyperexecute
chmod +x hyperexecute
```

#### For Linux:
```bash
curl -O https://downloads.lambdatest.com/hyperexecute/linux/hyperexecute
chmod +x hyperexecute
```

#### For Windows:
```bash
curl -O https://downloads.lambdatest.com/hyperexecute/windows/hyperexecute.exe
```

## Project Setup

### 1. Install Dependencies
Install the project dependencies:

```bash
npm install
```

### 2. Configure Detox
The project includes a `detox.config.js` file configured for LambdaTest:

```javascript
module.exports = {
  apps: { 
    "android.release": {
      "type": "android.apk",
      "binaryPath": "android/app/build/outputs/apk/release/app-release.apk",
      "build": "cd android ; ./gradlew assembleRelease assembleAndroidTest -DtestBuildType=release ; cd -"
    }
  },
  devices: {
    "hyperexecute.raw.device": {
      type: 'android.attached',
      device: {
        adbName: '.*'
      }
    }
  },
  configurations: {
    "lambdatest": {
      "device": "hyperexecute.raw.device",
      "app": "android.release"
    }
  }
};
```

## Running Tests on HyperExecute

### 1. Setup Test Scripts
The test execution is managed by two scripts in the `lambdatest/scripts` directory:

#### pre-setup.sh
This script handles the environment setup:
- Installs and configures nvm
- Sets up Node.js 18
- Configures Android SDK
- Installs project dependencies

#### execute.sh
This script runs the actual tests with the specified configuration.

### 2. Execute Tests
Run your tests using HyperExecute CLI:

```bash
./hyperexecute --user $LT_USERNAME --key $LT_ACCESS_KEY --config yaml/hyperexecute.yaml
```

The test script that will be executed is defined in `package.json`:
```json
{
  "scripts": {
    "test:lambdatest-android": "detox test --configuration lambdatest --loglevel trace --debug-synchronization 10000"
  }
}
```





## View Test Results
1. Visit [LambdaTest Dashboard](https://automation.lambdatest.com/build)
2. Find your test execution
3. View detailed reports, screenshots, and logs

## Additional Resources
* [LambdaTest Documentation](https://www.lambdatest.com/support/docs/)
* [HyperExecute Documentation](https://www.lambdatest.com/support/docs/hyperexecute-cli-run-tests/)
* [LambdaTest Blog](https://www.lambdatest.com/blog/)
* [LambdaTest Community](https://community.lambdatest.com/)

## Reporting Issues
If you face any issues while running the tests, please report them in the [issues section](https://github.com/LambdaTest/LT-detox/issues).
