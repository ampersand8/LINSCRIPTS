import os
import shutil
import datetime
cfgfile = "/etc/sysconfig/iptables"
searchvalue = "-A INPUT -j SCIS-CUSTOM-INPUT"
nrules = ["-A CUSTOM-INPUT -s xx.xx.xx.xx -p tcp -m tcp --dport 22 -j ACCEPT\n","-A CUSTOM-INPUT -s xx.xx.xx.xx -p tcp -m tcp --dport 22 -j ACCEPT\n","-A CUSTOM-INPUT -s xx.xx.xx.xx -p tcp -m tcp --dport 22 -j ACCEPT\n","-A CUSTOM-INPUT -s xx.xx.xx.xx -p tcp -m tcp --dport 22 -j ACCEPT\n","-A CUSTOM-INPUT -s xx.xx.xx.xx -p tcp -m tcp --dport 22 -j ACCEPT\n","-A CUSTOM-INPUT -s xx.xx.xx.xx -p tcp -m tcp --dport 22 -j ACCEPT\n"]
i = 0
if os.path.isfile(cfgfile):
  print "IPTables file exisits, continuing"
  bkpfile = cfgfile + datetime.datetime.now().strftime("%Y%m%d_%H%M")
  shutil.copy2(cfgfile,bkpfile)
  if os.path.isfile(bkpfile):
    print "Backup file successfully created"
  rule_list = open(cfgfile).readlines()
  new_rulelist = []
  for rule in rule_list:
    new_rulelist.append(rule)
    if searchvalue in rule:
      print "Inserting new rules"
      new_rulelist.extend(nrules)
      i += 1
  if i < 2:
    print "Writing changes to file"
    outfile = open(cfgfile,'w')
    outfile.writelines(new_rulelist)
    outfile.close()
  else:
    print "Too many search results, aborting"
else:
  print "IPTables file does not exist"
