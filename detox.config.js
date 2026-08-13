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
      "ios.release": {
        "type": "ios.app",
        "binaryPath": "ios/build/Build/Products/Release-iphonesimulator/example.app",
        "build": "xcodebuild -workspace ios/example.xcworkspace -scheme example -configuration Release -sdk iphonesimulator -derivedDataPath ios/build -UseNewBuildSystem=YES",
      },
      "ios.debug": {
        "type": "ios.app",
        "binaryPath": "ios/build/Build/Products/Debug-iphonesimulator/example.app",
        "build": "xcodebuild -workspace ios/example.xcworkspace  -scheme example -configuration Debug -sdk iphonesimulator -derivedDataPath ios/build",
        "start": "scripts/start-rn.sh ios",
      },
      "android.debug": {
        "type": "android.apk",
        "binaryPath": "android/app/build/outputs/apk/debug/app-debug.apk",
        "build": "cd android ; ./gradlew assembleDebug assembleAndroidTest -DtestBuildType=debug ; cd -",
        "start": "scripts/start-rn.sh android",
        reversePorts: [8081]
      },
      "android.release": {
        "type": "android.apk",
        "binaryPath": "android/app/build/outputs/apk/release/app-release.apk",
        "testBinaryPath": "android/app/build/outputs/apk/androidTest/release/app-release-androidTest.apk",
        "build": "cd android ; ./gradlew assembleRelease assembleAndroidTest -DtestBuildType=release ; cd -"
      },
      "hyperexecute.raw.android": {
        "type": "android.apk",
        "binaryPath": "lambdatest/apps/app-release.apk",
        "testBinaryPath": "lambdatest/apps/testApp/app-release-androidTest.apk",
        "build": "cd android ; ./gradlew assembleDebug assembleAndroidTest -DtestBuildType=debug ; cd -",
        "launchArgs": {
          "detoxServer": "ws://localhost:8099",
          "detoxSessionId": "com.wix.demo.react.native"
        }
      }
    },
    devices: {
      simulator: {
        type: "ios.simulator",
        headless: false,
        // On HyperExecute, lambdatest/scripts/execute.sh exports DETOX_SIM_UDID for the
        // already-booted (and video-recorded) simulator so Detox attaches to it instead of
        // booting its own unrecorded one. Falls back to a device type for local runs.
        device: process.env.DETOX_SIM_UDID
          ? { id: process.env.DETOX_SIM_UDID }
          : {
              type: "iPhone 14",
            }
      },
      emulator: {
        type: "android.emulator",
        headless: Boolean(process.env.CI),
        gpuMode: process.env.CI ? 'off' : undefined,
        device: {
          avdName: "Pixel_3a_API_34"
        },
        reversePorts: [8081],
      },
      attached: {
        type: 'android.attached',
        device: {
          adbName: 'emulator-5554'
        }
      },
      "hyperexecute.raw.device": {
        type: 'android.attached',
        device: {
          adbName: '.*'
        }
      },
      "genymotion.emulator.uuid": {
        type: "android.genycloud",
        device: {
          recipeUUID: "9baf12f9-a645-4ffa-a688-0e92584d6194"
        },
      },
      "genymotion.emulator.name": {
        type: "android.genycloud",
        device: {
          recipeName: "Detox_Pixel_3a_API_34"
        },
      }
    },
    configurations: {
      "ios.sim.release": {
        "device": "simulator",
        "app": "ios.release"
      },
      "ios.sim.debug": {
        "device": "simulator",
        "app": "ios.debug"
      },
      "ios.manual": {
        "type": "ios.manual",
        "behavior": {
          "launchApp": "manual"
        },
        "artifacts": false,
        "session": {
          "autoStart": true,
          "server": "ws://localhost:8099",
          "sessionId": "com.wix.demo.react.native"
        }
      },
      "android.emu.debug": {
        "device": "emulator",
        "app": "android.debug"
      },
      "android.emu.release": {
        "device": "emulator",
        "app": "android.release"
      },
      "android.att.release": {
        "device": "attached",
        "app": "android.release"
      },
      "lambdatest": {
        "device": "hyperexecute.raw.device",
        "app": "android.release"
      },
    }
  };
