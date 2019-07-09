# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=FEDOROV
MODULE_VERSION=1.01
inherit perl-module

DESCRIPTION="File stat bit mask constants"

LICENSE="|| ( GPL-2 GPL-3 )" # GPL-2+
SLOT="0"
KEYWORDS="amd64 s390 x86"
IUSE=""

SRC_TEST="do"
