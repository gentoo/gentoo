#!/bin/sh
# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This cron script updates the Google SafeBrowsing lists for the use of the
# Mail-SpamAssassin-Plugin-GoogleSafeBrowsing plugin.
# It should be run every 25-30 minutes! http://code.google.com/apis/safebrowsing/developers_guide.html#AcceptableUsage
CONFFILE="/etc/mail/spamassassin/24_google_safebrowsing.cf"
OUTDIR="$(awk '/^google_safebrowsing_dir/{print $2}' "${CONFFILE}")"
APIKEY="$(awk '/^google_safebrowsing_apikey/{print $2}' "${CONFFILE}")"
LISTS="$(awk '/^google_safebrowsing_blocklist/{printf "%s ",$2}' "${CONFFILE}")"
if [ "$APIKEY" == "DEADBEEF" ]; then
	echo "No API key!" 1>&2
	exit 1
fi
# Wait a little while, to avoid hammering the server
sleep $(($RANDOM % 120))
# Use LISTS unquoted!
for LIST in ${LISTS}; do
	blocklist_updater --apikey "$APIKEY" --blocklist ${LIST} --dbfile ${OUTDIR}/${LIST}-db
done
