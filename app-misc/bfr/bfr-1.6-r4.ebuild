# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="General-purpose command-line pipe buffer"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://www.glines.org/bin/pk/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 sparc x86"

BDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${P}-perl.patch
	"${FILESDIR}"/${P}-long-types.patch
)

src_configure() {
	tc-export CC
	default
}
