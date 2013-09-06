#!/usr/bin/expect
## Author: Simon Peter, Swisscom IT Services AG
## Created: 15.08.2013
## Last modified: 28.08.2013
## Version: 0.3
## Script to automatically connect to SSH Server, in conjunction with ssh_connect.sh

set timeout 1

## Get the arguments from ssh_connect.sh
set host [lindex $argv 0]
set pass [lindex $argv 1]

## Exitafter still in works - don't use it!
set exitafter [lindex [split [lindex $argv 2] "="] 1]
set master [lindex [split [lindex $argv 3] "="] 1]

## Receive commands at the end as arguments
set command ""
for {set i 4} {$i <= $argc} {incr i} {
  append command [lindex $argv $i]
  append command " "
}

## If the host is missing, abort
if {[string length $host] == 0} {
  puts "auto_connect.sh wird automatisch von ssh_connect.sh aufgerufen. Abbruch..."
}


## Logfile definition
set outfile "ssh_connect.log"
set output [open $outfile a+]

set commandlen [string length $command]


## Start the ssh connection, auto password reply and so on...
spawn ssh -qt -o StrictHostKeyChecking=no -o CheckHostIP=no -o NumberOfPasswordPrompts=1 $host
expect {
  "password:*" {
    send -- "$pass\r"
    expect {
      default {
        if {$master == 1} {
          send -- "sudo su - root\r"
        }
        if {$commandlen > 0} {
          send -- "$command\r"
        }
        if {$exitafter == 0} {
          interact
        } else {
          exit 0
        }
      }
      "Permission denied*" {
        puts $output "$host: hat SSH Zugriff verweigert"
      }
    }
  }
  "Name or service not known" {
    puts $output "$host: hat SSH Verbindung nicht akzeptiert"
  }
}
close $output
