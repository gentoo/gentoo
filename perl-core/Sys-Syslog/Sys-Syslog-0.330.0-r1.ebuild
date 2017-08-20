# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SAPER
MODULE_VERSION=0.33
inherit perl-module

DESCRIPTION="Provides same functionality as BSD syslog"

SLOT="0"
KEYWORDS=""
IUSE=""

# Tests disabled - they attempt to verify on the live system
#SRC_TEST="do"
