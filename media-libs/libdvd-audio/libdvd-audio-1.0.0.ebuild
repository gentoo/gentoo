# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="library for extracting audio from DVD-Audio discs"
HOMEPAGE="https://sourceforge.net/projects/libdvd-audio/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

BDEPEND="doc? ( dev-python/sphinx )"

src_configure() {
	tc-export CC AR
}

src_compile() {
	emake
	use doc && emake -C docs man
}

src_install() {
	emake DESTDIR="${ED}" PREFIX=/usr LIB_DIR=/usr/$(get_libdir) install
	use doc && doman docs/build/man/*
	use static-libs || { find "${ED}/usr" -name '*.a' -delete || die; }
}
