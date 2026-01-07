# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=glw-"${PV}"

DESCRIPTION="Mesa GLw library"
HOMEPAGE="https://mesa3d.sourceforge.net/"
SRC_URI="ftp://ftp.freedesktop.org/pub/mesa/glw/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="+motif"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/motif:0
	virtual/opengl"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${P}-gcc10-fno-common.patch )

src_configure() {
	econf \
		--disable-static \
		--enable-motif
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
