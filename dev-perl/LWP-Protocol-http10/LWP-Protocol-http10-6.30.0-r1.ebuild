# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GAAS
DIST_VERSION=6.03
inherit perl-module

DESCRIPTION="Legacy HTTP/1.0 support for LWP"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	>=dev-perl/HTTP-Message-6.0.0
	virtual/perl-IO
	>=dev-perl/libwww-perl-6.0.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
