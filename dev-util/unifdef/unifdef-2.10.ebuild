# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Remove #ifdef'ed lines from a file while otherwise leaving the file alone"
HOMEPAGE="https://dotat.at/prog/unifdef/"
SRC_URI="https://dotat.at/prog/unifdef/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"

DOCS=( README )

src_prepare() {
	sed -i '/^prefix/s:=.*:=/usr:' Makefile || die
	tc-export CC
	default
}
