# Use the latest Swift from Docker Hub
FROM swift:4.0.2

# Add current application
ADD . /app
WORKDIR /app

# Install MySQL Client and Perfect dependencies
RUN apt-get update && apt-get install -y apt-utils && apt-get install -y libmysqlclient-dev libssl-dev uuid-dev

# Expose default port for App Engine
EXPOSE 8080

# Build release.
RUN swift build --configuration release -Xswiftc -lPerfectCZlib -Xswiftc -lPerfectCHTTPParser

# Delete the source code
RUN rm -rf Sources

# Run the application
ENTRYPOINT [".build/release/BalanceServer"]
