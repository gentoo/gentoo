# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Linux-Smaps/Linux-Smaps-0.120.0.ebuild,v 1.1 2013/08/16 07:48:16 patrick Exp $

EAPI=5

MODULE_AUTHOR=OPI
MODULE_VERSION=0.12
inherit perl-module linux-info

DESCRIPTION="Linux::Smaps - a Perl interface to /proc/PID/smaps"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CONFIG_CHECK="~MMU ~PROC_PAGE_MONITOR"
