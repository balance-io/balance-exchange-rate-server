# Balance Server is the backend software that powers the Balance app

## New developer setup instructions for macOS:

### Prerequisites:
- Install MySQL 5.7 (`brew update && brew install mysql && brew services start mysql`)
- Setup test data (instructions later)

### Build instructions:
- Clone repo
- Run `swift build` from the root directory to pull all dependencies and confirm it builds
- Run `swift test` to run unit tests
- Run `swift package generate-xcodeproj` to create an Xcode project
- Open `BalanceServer.xcworkspace` to get access to a Playground that includes the Perfect framework as well as the project generated above
- To run and debug the app in Xcode, choose the BalanceServer target and click run
- Before running tests on Xcode. Install mysql. User `root` pass is `test` create database `balance` by using `mysql -u root -e "create database balance"`
- To run the unit tests, choose the BalanceServer-Package target, choose My Mac from the menu directly to the right of the target selection menu, hit Command + U or use the menu option

### Notes:
- Dependencies and xcodeproj are not checked into the repo due to how the swift package manager works, so any changes you make will only be persisted locally
- The server runs both on Mac (built and run from command line or from Xcode) and on Linux (including inside Docker) 

