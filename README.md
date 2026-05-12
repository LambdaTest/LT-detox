# LT-Detox — TestMu AI (Formerly LambdaTest)
Run your Detox tests on TestMu AI Real Device Cloud Platform using HyperExecute.

## Prerequisites
1. Clone this repository
2. Ensure you have the following installed:
   - Node.js 18 (required)
   - npm (comes with Node.js)
   - React Native development environment
   - [HyperExecute CLI](https://www.testmuai.com/hyperexecute)

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

### 2. Set TestMu AI Credentials
Export your TestMu AI credentials. You can get these from your [TestMu AI Profile](https://accounts.lambdatest.com/detail/profile)

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
The project includes a `detox.config.js` file configured for TestMu AI:

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
# For sequential test execution
./hyperexecute --user $LT_USERNAME --key $LT_ACCESS_KEY --config yaml/hyperexecute.yaml

# For parallel test execution
./hyperexecute --user $LT_USERNAME --key $LT_ACCESS_KEY --config yaml/hyperexecuteParallel.yaml
```

The test scripts that will be executed are defined in `package.json`:
```json
{
  "scripts": {
    "test:lambdatest-android": "detox test --configuration lambdatest --loglevel trace --debug-synchronization 10000",
    "test:firstTest": "detox test --configuration lambdatest --testNamePattern='should have welcome screen' --loglevel trace --debug-synchronization 10000",
    "test:secondTest": "detox test --configuration lambdatest --testNamePattern='should show hello screen after tap' --loglevel trace --debug-synchronization 10000",
    "test:thirdTest": "detox test --configuration lambdatest --testNamePattern='should show goodbye screen after tap' --loglevel trace --debug-synchronization 10000"
  }
}
```

### 3. Parallel Test Execution
The project supports running tests in parallel using HyperExecute. This is configured through:

1. `yaml/hyperexecuteParallel.yaml`:
   - Sets concurrency level (3 parallel devices)
   - Configures test reporting
   - Defines test discovery and execution settings

2. `lambdatest/discoveryParallel.txt`:
   - Lists the test scripts to be executed in parallel:
     ```
     test:firstTest
     test:secondTest
     test:thirdTest
     ```

### 4. Test Reports
The project is configured to generate both HTML and JUnit test reports:

1. HTML Reports:
   - Generated using `jest-html-reporter`
   - Available at `reports/test-report.html`
   - Includes detailed test results and failure messages

2. JUnit Reports:
   - Generated using `jest-junit`
   - Available at `reports/junit.xml`
   - Useful for CI/CD integration

The reporting configuration is managed in `e2e/jest.config.js`:
```javascript
reporters: [
  "detox/runners/jest/reporter",
  ["jest-html-reporter", {
    "pageTitle": "Detox Test Report",
    "outputPath": "./reports/test-report.html",
    "includeFailureMsg": true
  }],
  ["jest-junit", {
    "outputDirectory": "./reports",
    "outputName": "junit.xml",
    "ancestorSeparator": " › ",
    "uniqueOutputName": "false",
    "suiteNameTemplate": "{filepath}",
    "classNameTemplate": "{classname}",
    "titleTemplate": "{title}"
  }]
]
```

## View Test Results
1. Visit [TestMu AI Dashboard](https://automation.lambdatest.com/build)
2. Find your test execution
3. View detailed reports, screenshots, and logs

## Additional Resources
* [TestMu AI Documentation](https://www.testmuai.com/support/docs/)
* [HyperExecute Documentation](https://www.testmuai.com/support/docs/hyperexecute-cli-run-tests/)
* [TestMu AI Blog](https://www.testmuai.com/blog/)
* [TestMu AI Community](https://community.testmuai.com/)

## Reporting Issues
If you face any issues while running the tests, please report them in the [issues section](https://github.com/LambdaTest/LT-detox/issues).

## 🚀 [LambdaTest is Now TestMu AI](https://www.testmuai.com/lambdatest-is-now-testmuai/)

👋 Welcome to TestMu AI, the next evolution of LambdaTest. As of January 2026, LambdaTest has officially rebranded to TestMu AI. We have evolved from a cross-browser testing cloud into a unified, AI-native quality engineering platform designed for the modern DevOps era.

Whether you have been part of the LambdaTest community for years or are just discovering TestMu AI, our mission remains the same: to help you ship faster with high-scale test execution, autonomous testing, and deep quality analytics.

**🔄 Our Rebrand Journey**

We chose the name TestMu AI to reflect our shift towards intelligent, autonomous testing. While our identity has changed, our core technology and commitment to the testing community stay the same.

**✨ Specialties**

- 🤖 AI-Native Test Execution (Formerly LambdaTest)
- ⚡ Autonomous Test Automation
- 🌐 Cross-Browser & Mobile Testing
- 📊 Unified Quality Intelligence

👉 Find [LambdaTest's New Home](https://www.testmuai.com/).