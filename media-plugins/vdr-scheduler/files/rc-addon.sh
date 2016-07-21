# $Id$
#
# rc-addon-script for plugin scheduler
#
# Joerg Bornkessel hd_brummy@gentoo.org

. /etc/conf.d/vdr.scheduler

: ${SCHEDULER_LOGFILE:=/var/log/vdr.scheduler}
: ${SCHEDULER_LOGLEVEL:=0}
: ${SCHEDULER_TASK_LOGDIR:=/var/log}

plugin_pre_vdr_start() {

  add_plugin_param "-l ${SCHEDULER_LOGFILE}"
  add_plugin_param "-v ${SCHEDULER_LOGLEVEL}"
  add_plugin_param "-d ${SCHEDULER_TASK_LOGDIR}"
}
