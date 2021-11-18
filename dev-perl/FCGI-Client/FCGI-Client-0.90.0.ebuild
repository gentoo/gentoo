# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOKUHIROM
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Client library for fastcgi protocol"

SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~ia64 ~m68k ~sparc ~x86"

RDEPEND="
	virtual/perl-IO
	dev-perl/Moo
	dev-perl/Type-Tiny
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0
"
