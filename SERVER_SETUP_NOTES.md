Server Setup Notes (work in progress, will fill in some more details later):
1. Install Nginx (config based on countly)
   a. mkdir -p /var/cache/nginx/exchangerates
   b. chown -R www-data /var/cache/nginx
2. Install certbot and create certificate (no need to create cron entry for renewal, it does it for you)
3. Install Swift in standard way to /opt/swift
   a. Create dir for Swift release inside /opt/swift
   b. Symlink /opt/swift/swift to latest release
   c. Fix missing libs:
      1) touch /etc/ld.so.conf.d/swift.conf
      2) echo "/opt/swift/swift/usr/lib/swift/linux" > /etc/ld.so.conf.d/swift.conf
      3) ldconfig
4. Install MySQL 
   a. apt-get install mysql-server mysql-client libmysqlclient-dev
   b. Setup the balance user and create balance db
5. Install other dependencies
   a. apt-get install libcurl4-openssl-dev
6. Build the project using a Linux VM
   a. swift build --configuration release
7. Upload initial build and scripts to server
   a. On server
      1) mkdir /opt/exchangerates
      2) chown root:admin /opt/exchangerates
      3) chmod 775 exchangerates
   b. On build machine
      1) scp ./.build/x86_64-unknown-linux/release/BalanceExchangeRateServer exchangerates.balancemy.money:/opt/exchangerates/BalanceExchangeRateServer
      2) scp ./server/scripts/promoteBuild ./server/scripts/revertBuild exchangerates.balancemy.money:/opt/exchangerates/
   c. On server
      1) cd /opt/exchangerates/
      2) chown root:root BalanceExchangeRateServer promoteBuild revertBuild 
      3) chmod 755 BalanceExchangeRateServer
      4) chmod 744 promoteBuild revertBuild
6. Install the service
   a. Copy server/systemd/exchangerates.service to /etc/systemd/system/
      1) Note that Finder is ridulously stupid and will show a .app extension on this file even though it doesn't exist. Don't try and rename it, it won't work. Just trust the terminal.
   b. systemctl daemon-reload
   c. touch /var/log/exchangerates.log
   d. chgrp exchangerates exchangerates.log
   e. chmod g+w exchangerates.log
   f. service exchangerates start
   g. systemctl enable exchangerates.service
      1) This ensures it will run on reboot
7. Setup the cron jobs
   a. copy server/cron/exchangerates to /etc/cron.d
   b. chown root:root /etc/cron.d/exchangerates
   c. chmod 644 /etc/cron.d/exchangerates
   b. touch /var/log/exchangerates_cron.log
   c. chgrp exchangerates exchangerates_cron.log
   d. chmod g+w exchangerates_cron.log
8. Upload new build
   a. On build machine
      1) swift build --configuration release
      2) scp ./.build/x86_64-unknown-linux/release/BalanceExchangeRateServer exchangerates.balancemy.money:/opt/exchangerates/BalanceExchangeRateServer.new
   b. On server
      1) cd /opt/exchangerates
      2) sudo promoteBuild
      3) If something goes wrong: sudo revertBuild