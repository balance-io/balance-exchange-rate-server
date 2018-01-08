Server Setup Notes (work in progress, will fill in some more details later):
1. Install Nginx (config based on countly)
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
5. Install other dependencies
   a. apt-get install libcurl4-openssl-dev
6. Install the service
   a. Copy exchangerates.service to /etc/systemd/system/
   b. systemctl daemon-reload
   c. touch /var/log/exchangerates.log
   d. chgrp exchangerates exchangerates.log
   e. chmod g+w exchangerates.log
   f. service exchangerates start