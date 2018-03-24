# Add "winbind" to the daemon_list if you also want winbind to start.
# Replace "smbd nmbd" by "samba4" if you want the active directory domain controller part or the ntvfs
# file server part or the rpc proxy to start.
# Note that samba4 controls 'smbd' by itself, thus it can't be started manually. You can, however,
# tweak the behaviour of a samba4-controlled smbd by modifying your '/etc/samba/smb.conf' file
# accordingly.
daemon_list="smbd nmbd"

#----------------------------------------------------------------------------
# Daemons calls: <daemon_name>_<command_option>
#----------------------------------------------------------------------------
my_service_name="samba"
my_service_PRE="unset TMP TMPDIR"
my_service_POST=""

#----------------------------------------------------------------------------
# Daemons calls: <daemon_name>_<command_option>
#----------------------------------------------------------------------------
smbd_start_options="-D"
smbd_start="start-stop-daemon --start --exec /usr/sbin/smbd -- ${smbd_start_options}"
smbd_stop="start-stop-daemon --stop --exec /usr/sbin/smbd"
smbd_reload="killall -HUP smbd"

nmbd_start_options="-D"
nmbd_start="start-stop-daemon --start --exec /usr/sbin/nmbd -- ${nmbd_start_options}"
nmbd_stop="start-stop-daemon --stop --exec /usr/sbin/nmbd"
nmbd_reload="killall -HUP nmbd"

samba4_start_options=""
samba4_start="start-stop-daemon --start --exec /usr/sbin/samba -- ${samba4_start_options}"
samba4_stop="start-stop-daemon --stop --exec /usr/sbin/samba"
samba4_reload="killall -HUP samba"

winbind_start_options=""
winbind_start="start-stop-daemon --start --exec /usr/sbin/winbindd -- ${winbind_start_options}"
winbind_stop="start-stop-daemon --stop --exec /usr/sbin/winbindd"
winbind_reload="killall -HUP winbindd"

