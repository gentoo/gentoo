# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MLEHMANN
DIST_VERSION=3.8
inherit perl-module

DESCRIPTION="extremely light-weight Lempel-Ziv-Free compression"
# lzfP.h for BSD/GPL2+
LICENSE="|| ( Artistic GPL-1+ ) || ( BSD-2 GPL-2+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
