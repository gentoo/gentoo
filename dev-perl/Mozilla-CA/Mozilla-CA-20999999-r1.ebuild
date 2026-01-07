# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module
SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.gz"

DESCRIPTION="Mozilla's CA cert bundle in PEM format (Gentoo stub)"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="app-misc/ca-certificates"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
