# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="DTS Coherent Acoustics decoder with support for HD extensions"
HOMEPAGE="https://github.com/foo86/dcadec"
SRC_URI="https://github.com/foo86/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips x86"

PATCHES=( "${FILESDIR}"/${P}-respect-CFLAGS.patch )

src_configure() {
	tc-export AR CC

	# Build shared libs
	echo 'CONFIG_SHARED=1' >> .config || die
}

src_compile() {
	PREFIX="${EPREFIX}"/usr LIBDIR="${EPREFIX}"/usr/$(get_libdir) \
		emake -f "${S}"/Makefile all
}

src_install() {
	PREFIX="${EPREFIX}"/usr LIBDIR="${EPREFIX}"/usr/$(get_libdir) \
		emake -f "${S}"/Makefile DESTDIR="${D}" install

	# Rename the executable since it conflicts with libdca.
	mv "${ED}"/usr/bin/dcadec{,-new} || die

	dodoc CHANGELOG.md README.md
}
