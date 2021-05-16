# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Unix Amiga Delitracker Emulator - plays old Amiga tunes through UAE emulation"
HOMEPAGE="https://zakalwe.fi/uade"
SRC_URI="https://zakalwe.fi/uade/uade2/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="media-libs/libao"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog doc/BUGS doc/PLANS )

PATCHES=( "${FILESDIR}"/${P}-configure.patch )

src_configure() {
	tc-export CC

	./configure \
		--prefix="${EPREFIX}"/usr \
		--package-prefix="${D}" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--with-text-scope \
		--without-xmms \
		--without-audacious || die
}

src_install() {
	default
	doman doc/uade123.1
}
