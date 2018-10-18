# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Virtual package for linux sources build dependencies"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 mips ppc ppc64 s390 sh sparc x86"
RDEPEND="
	dev-lang/perl
	sys-devel/bc
	sys-devel/bison
	sys-devel/flex
	sys-devel/make
	>=sys-libs/ncurses-5.2
	virtual/libelf
"
