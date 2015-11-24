# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=OPI
MODULE_VERSION=0.13
inherit perl-module linux-info

DESCRIPTION="Perl interface to /proc/PID/smaps"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CONFIG_CHECK="~MMU ~PROC_PAGE_MONITOR"

SRC_TEST="do parallel"

# Remove dubious tests.
PERL_RM_FILES=(
	t/0{3,4}.t
)
