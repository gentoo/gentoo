# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TONYC
DIST_VERSION=1.003
inherit perl-module

DESCRIPTION="An XS implementation of POE::Loop, using Linux epoll(2)"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/POE-1.287.0
	>=dev-perl/POE-Test-Loops-1.33.0
"
BDEPEND="${RDEPEND}
"
