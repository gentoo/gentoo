[Unit]
Description=Linux Container %I
After=network.target

[Service]
Restart=always
ExecStart=/usr/sbin/lxc-start -n %i
ExecReload=/usr/sbin/lxc-restart -n %i
ExecStop=/usr/sbin/lxc-stop -n %i

[Install]
WantedBy=multi-user.target
