# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module
SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.gz"

DESCRIPTION="Mozilla's CA cert bundle in PEM format (Gentoo stub)"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="app-misc/ca-certificates"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
