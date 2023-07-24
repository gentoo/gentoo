# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAYASHI
DIST_VERSION=1.45
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Perl extension for the GNU Readline/History Library"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=sys-libs/readline-6.2:=
	sys-libs/ncurses:=
"
DEPEND="
	${RDEPEND}
"
# Newer MakeMaker needed for macOS at least
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-7.580.0
"

src_prepare() {
	default

	# search_termlib() selects termcap when sys-libs/libtermcap-compat is installed
	# despite the absence of libtermcap.so symlink
	sed -i -e \
		"s/search_termlib()/search_lib('-ltinfo') || search_lib('-lncurses')/" \
		Makefile.PL || die
}
