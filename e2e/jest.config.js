/** @type {import('jest').Config} */
module.exports = {
  maxWorkers: 1,
  globalSetup: "./globalSetup.ts",
  globalTeardown: "detox/runners/jest/globalTeardown",
  testEnvironment: "detox/runners/jest/testEnvironment",
  setupFilesAfterEnv: ["./setup.ts"],
  testRunner: "jest-circus/runner",
  testTimeout: 120000,
  testMatch: ["**/*.test.ts"],
  transform: {
    "\\.tsx?$": "ts-jest"
  },
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
  ],
  verbose: true
};
