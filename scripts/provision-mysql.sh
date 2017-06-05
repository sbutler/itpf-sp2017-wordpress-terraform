#!/bin/bash

while getopts "h:u:p:" opt; do
    case $opt in
        h)
            mysql_host="$OPTARG"
            ;;
        u)
            mysql_adminuser="$OPTARG"
            ;;

        p)
            mysql_adminpass="$OPTARG"
            ;;

        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

if [[ -z $mysql_host ]]; then
    echo "MySQL host (-h) is a required argument" >&2
    exit 1
fi

if [[ -z $mysql_adminuser ]]; then
    echo "MySQL admin user (-u) is a required argument" >&2
    exit 1
fi

if [[ -z $mysql_adminpass ]]; then
    echo "MySQL admin password (-p) is a required argument" >&2
    exit 1
fi

shift $((OPTIND-1))
new_name="$1"
new_user="$2"
new_pass="$3"

if [[ -e "/Applications/MySQLWorkbench.app/Contents/MacOS" ]]; then
    export PATH="$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS"
fi

cat <<EOScript | mysql -h "$mysql_host" -u "$mysql_adminuser" -p"$mysql_adminpass"
CREATE DATABASE $new_name;
GRANT USAGE ON *.* TO '$new_user'@'%' IDENTIFIED BY '$new_pass';
GRANT ALL ON $new_name.* TO '$new_user'@'%';
EOScript
