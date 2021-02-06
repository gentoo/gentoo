# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Minimal command-line source browsing tool similar to cscope"
HOMEPAGE="https://uzix.org/cgvg.html"
SRC_URI="https://uzix.org/cgvg/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"
