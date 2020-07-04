# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="TCAINE"
DIST_VERSION="0.08"
inherit perl-module

DESCRIPTION="Internet Route Registry daemon (IRRd) client"

RDEPEND="virtual/perl-IO"
DEPEND="virtual/perl-ExtUtils-MakeMaker
	${RDEPEND}"

SLOT="0"
KEYWORDS="~amd64 ~x86"

src_test() {
	einfo "Tests deactivated; need network connectivity"
}
