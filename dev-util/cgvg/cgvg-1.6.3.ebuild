# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Minimal command-line source browsing tool similar to cscope"
HOMEPAGE="http://uzix.org/cgvg.html"
SRC_URI="http://uzix.org/cgvg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"
