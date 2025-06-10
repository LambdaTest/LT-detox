/** @type {Detox.DetoxConfig} */
module.exports = {
  logger: {
    level: process.env.CI ? 'debug' : undefined,
  },
  testRunner: {
    args: {
      config: 'e2e/jest.config.js',
      maxWorkers: process.env.CI ? 2 : undefined,
      _: ['e2e']
    },
  },
  artifacts: { 
    plugins: {
      log: process.env.CI ? 'failing' : undefined,
      screenshot: process.env.CI ? 'failing' : undefined,
    },
  },
  apps: { 
    "android.release": {
      "type": "android.apk",
      "binaryPath": "android/app/build/outputs/apk/release/app-release.apk",
      "build": "cd android ; ./gradlew assembleRelease assembleAndroidTest -DtestBuildType=release ; cd -"
    },
    "hyperexecute.raw.android": {
      "type": "android.apk",
      "binaryPath": "lambdatest/apps/app-release.apk", // ??
      "testBinaryPath": "lambdatest/apps/testApp/app-release-androidTest.apk", // ??
      "build": "cd android ; ./gradlew assembleDebug assembleAndroidTest -DtestBuildType=debug ; cd -",
      "launchArgs": {
        "detoxServer": "ws://localhost:8099",
        "detoxSessionId": "com.wix.demo.react.native"
      }
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
