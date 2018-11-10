# /etc/conf.d/iscsid

# config file to use
CONFIG_FILE=/etc/iscsi/iscsid.conf

# you need to specify an initiatorname in the file
INITIATORNAME_FILE=/etc/iscsi/initiatorname.iscsi

# options to pass to iscsid
OPTS="-i ${INITIATORNAME_FILE}"

# Start automatic targets when iscsid is started
AUTOSTARTTARGETS="yes"

# if set to "strict", iscsid will stop, if connecting the
# autostart targets failed
# AUTOSTART="strict"

