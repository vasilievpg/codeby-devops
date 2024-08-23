#!/bin/bash
mysqldump -u root -pyour_mysql_root_password example_db > /opt/mysql_backup/example_db_backup_$(date +\%F_\%T).sql