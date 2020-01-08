# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="a graphics library built on top of imlib2"
HOMEPAGE="http://freecode.com/projects/giblib http://www.linuxbrit.co.uk/giblib/"
SRC_URI="http://www.linuxbrit.co.uk/downloads/${P}.tar.gz"

LICENSE="feh"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~sh sparc x86"

RDEPEND="
	media-libs/freetype
	media-libs/imlib2:=[X]
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.2.4-fix-build-system.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
