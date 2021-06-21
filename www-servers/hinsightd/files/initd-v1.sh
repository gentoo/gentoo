#!/sbin/openrc-run

NAME=$RC_SVCNAME
RUN_DIR=/var/run/$NAME
LOG_DIR=/var/log/$NAME
TMP_DIR=/var/tmp/$NAME
CWD_DIR=/var/www/localhost
PID_FILE=$RUN_DIR/$NAME.pid
CFG_FILE=/etc/hinsightd/main.lua
LOG_FILE=$LOG_DIR/hindsight.log

RUN_FILE=/usr/sbin/hinsightd
RUN_USER="hinsightd"

extra_commands="checkconfig reload"

command=$RUN_FILE
command_args="--config $CFG_FILE --logdir $LOG_DIR --cwd $CWD_DIR --pidfile $PID_FILE --tmpdir $TMP_DIR --log $LOG_FILE"
pidfile="$PID_FILE"
command_args_background="--daemonize"
command_user="$RUN_USER:$RUN_USER"

depend() {
  use net
}

checkconfig() {
  start-stop-daemon --quiet --user $RUN_USER --start --exec $command -- --check $command_args
}

start_pre() {
  checkpath --directory --owner $command_user --mode 06770 $LOG_DIR $TMP_DIR $RUN_DIR
  checkconfig || return 1
}

reload() {
  if ! service_started "${NAME}" ; then
    eerror " * ERROR ${NAME} isn't running"
    return 1
  fi

  checkconfig || return 1

  echo " * Reloading ${NAME} ..."

  start-stop-daemon --quiet --signal USR1 --pidfile ${PID_FILE}
  eend $?
}


