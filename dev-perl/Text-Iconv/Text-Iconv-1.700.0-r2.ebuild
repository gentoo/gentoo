# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MPIOTR
DIST_VERSION=1.7
inherit perl-module

DESCRIPTION="A Perl interface to the iconv() codeset conversion function"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris"
IUSE=""

RDEPEND="virtual/libiconv"
DEPEND="${RDEPEND}"
