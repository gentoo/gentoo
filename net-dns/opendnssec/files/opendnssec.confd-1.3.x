# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/opendnssec/files/opendnssec.confd-1.3.x,v 1.1 2013/07/23 20:06:48 mschiff Exp $

# Variables containing default binaries used in the opendnssec
# initscript. You can alter them to another applications/paths
# if required.

CHECKCONFIG_BIN=/usr/bin/ods-kaspcheck
CONTROL_BIN=/usr/sbin/ods-control
ENFORCER_BIN=/usr/sbin/ods-enforcerd
SIGNER_BIN=/usr/sbin/ods-signerd
EPPCLIENT_BIN=/usr/sbin/eppclientd
EPPCLIENT_PIDFILE=/run/opendnssec/eppclientd.pid
