# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DIST_VERSION=1.01
DIST_AUTHOR=TIMA
inherit perl-module

DESCRIPTION="Object-oriented interface for developing Trackback clients and servers"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-perl/libwww-perl-5.831.0
	>=dev-perl/Class-ErrorHandler-0.10.0
"
BDEPEND="${RDEPEND}
"
