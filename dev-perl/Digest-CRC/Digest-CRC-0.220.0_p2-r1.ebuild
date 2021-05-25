# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=OLIMAUL
# https://rt.cpan.org/Ticket/Display.html?id=120669
DIST_VERSION=0.22.2
inherit perl-module
S="${WORKDIR}/${PN}-0.22"

DESCRIPTION="Generic CRC function"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 sparc x86 ~amd64-linux"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
"
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
