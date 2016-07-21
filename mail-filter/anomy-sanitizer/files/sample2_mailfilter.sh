#!/bin/sh
#
# spamassassin
#
# Simple filter to plug SpamAssassin only
# into the Postfix MTA, using the spamc / spamd
# daemon version of SpamAssassin.
#
# (Should result in higher performance on busy servers)
#
# NOTE: spamd must be running before using this script!
#
# For use with:
#    Postfix 20010228 or later
#    SpamAssassin 2.42 or later
#
############
#          #
# UNTESTED #
#          #
############


# VARIABLES
# ---------

# File locations
# (CHANGE AS REQUIRED TO MATCH YOUR SET-UP)
INSPECT_DIR="/var/spool/sanitizer"
#INSPECT_DIR="/var/spool/filter"
SENDMAIL="/usr/lib/sendmail -i"
ANOMY="/usr/share/anomy-sanitizer"
ANOMY_BIN="${ANOMY}/bin/sanitizer.pl"
ANOMY_CONF="/usr/share/anomy-sanitizer/anomy.conf"
#ANOMY_LOG="/dev/null"
ANOMY_LOG="/tmp/sanitizer.log"
SPAMASSASSIN="/usr/bin/spamassassin"
#SPAMASSASSIN_LOG="/dev/null"
SPAMASSASSIN_LOG="/tmp/spamassassin.log"
CAT="/bin/cat"

# Messages
UNABLE_TO_CD_INSPECTDIR="Impossible to change to ${INSPECT_DIR}"
MSG_CONTENT_REJECTED="Message content rejected"

# Exit codes from <sysexits.h>
EX_TEMPFAIL=75
EX_UNAVAILABLE=69

# Users that execute different filters
SPAMC_USER="sanitizer"

export ANOMY


# MAIN
# ----

cd ${INSPECT_DIR} || { echo ${UNABLE_TO_CD_INSPECTDIR} ; exit ${EX_TEMPFAIL}; }

# Clean up when done or when aborting.
trap "rm -f out.$$" 0 1 2 3 15

# sanitizer only
#${CAT} \
#	| ${ANOMY_BIN} ${ANOMY_CONF} 2>>${ANOMY_LOG} > out.$$ || \
#	{ echo ${MSG_CONTENT_REJECTED}; exit ${EX_UNAVAILABLE}; }

# sanitizer and SpamAssassin
${CAT} \
	| ${SPAMC} -f -u ${SPAMC_USER} 2>${SPAMASSASSIN_LOG} \
	| ${ANOMY_BIN} ${ANOMY_CONF} 2>>${ANOMY_LOG} > out.$$ || \
	{ echo ${MSG_CONTENT_REJECTED}; exit ${EX_UNAVAILABLE}; }

# SpamAssassin only
#${CAT} \
#	| ${SPAMC} -f -u ${SPAMC_USER} 2>${SPAMASSASSIN_LOG} > out.$$ || \
#	{ echo ${MSG_CONTENT_REJECTED}; exit ${EX_UNAVAILABLE}; }

$SENDMAIL "$@" < out.$$

exit 0

