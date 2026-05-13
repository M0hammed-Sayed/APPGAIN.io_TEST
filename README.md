# APPGAIN.io Test Project

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A test/demo project for exploring and validating the capabilities of the [APPGAIN.io](https://appgain.io) mobile marketing and engagement platform.

---

## Table of Contents

- [About](#about)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

---

## About

**APPGAIN.io_TEST** is a sandbox/test repository created to evaluate and demonstrate the APPGAIN.io platform. APPGAIN.io is a mobile marketing automation platform that empowers developers and marketers to:

- Send targeted **push notifications** to mobile users.
- Run **deep-linking** campaigns to drive in-app engagement.
- Automate **user segmentation** and messaging workflows.
- Track and analyze **campaign performance** in real-time.

This project provides sample integrations, test scripts, and configuration files to help teams quickly onboard and validate the APPGAIN.io SDK and API.

---

## Features

- ✅ APPGAIN.io SDK integration examples
- ✅ Push notification setup and testing
- ✅ Deep-link configuration samples
- ✅ User segmentation workflow demos
- ✅ Campaign analytics walkthrough
- ✅ REST API request examples

---

## Getting Started

Follow the steps below to set up the project locally and run the test scenarios.

### Prerequisites

Before you begin, make sure you have the following installed:

- [Node.js](https://nodejs.org/) v16 or higher (or the runtime appropriate for your stack)
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)
- An active **APPGAIN.io** account and API credentials ([sign up here](https://appgain.io))

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/M0hammed-Sayed/APPGAIN.io_TEST.git
   cd APPGAIN.io_TEST
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Set up environment variables**

   Copy the example environment file and fill in your APPGAIN.io credentials:

   ```bash
   cp .env.example .env
   ```

   Open `.env` and update the following values:

   ```env
   APPGAIN_APP_ID=your_app_id_here
   APPGAIN_API_KEY=your_api_key_here
   APPGAIN_SENDER_ID=your_sender_id_here
   ```

---

## Usage

### Run Tests

```bash
npm test
```

### Send a Test Push Notification

```bash
npm run notify
```

### Trigger a Deep Link

```bash
npm run deeplink -- --url "your-deeplink-url"
```

> **Note:** Replace command examples with the actual scripts available in `package.json` once the project is fully set up.

---

## Project Structure

```
APPGAIN.io_TEST/
├── src/
│   ├── notifications/   # Push notification examples
│   ├── deeplinks/       # Deep-link configuration
│   ├── segmentation/    # User segmentation demos
│   └── analytics/       # Campaign analytics helpers
├── tests/               # Test cases and integration tests
├── .env.example         # Environment variable template
├── package.json         # Project metadata and scripts
└── README.md            # Project documentation
```

---

## Configuration

| Variable            | Description                            | Required |
|---------------------|----------------------------------------|----------|
| `APPGAIN_APP_ID`    | Your APPGAIN.io application ID         | ✅ Yes   |
| `APPGAIN_API_KEY`   | Your APPGAIN.io API key                | ✅ Yes   |
| `APPGAIN_SENDER_ID` | Firebase Cloud Messaging Sender ID     | ✅ Yes   |
| `NODE_ENV`          | Runtime environment (development/test) | ❌ No    |

---

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a new feature branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -m "Add your feature"`
4. Push to your fork: `git push origin feature/your-feature-name`
5. Open a Pull Request.

Please make sure your code follows the existing style and that all tests pass before submitting a PR.

---

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT). See the [LICENSE](LICENSE) file for details.

---

## Contact

| Field    | Details                                                         |
|----------|-----------------------------------------------------------------|
| Author   | [M0hammed-Sayed](https://github.com/M0hammed-Sayed)            |
| Platform | [APPGAIN.io](https://appgain.io)                               |
| Issues   | [GitHub Issues](https://github.com/M0hammed-Sayed/APPGAIN.io_TEST/issues) |
