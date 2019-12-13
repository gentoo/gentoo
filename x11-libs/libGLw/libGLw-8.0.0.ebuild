# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=glw-"${PV}"

DESCRIPTION="Mesa GLw library"
HOMEPAGE="http://mesa3d.sourceforge.net/"
SRC_URI="ftp://ftp.freedesktop.org/pub/mesa/glw/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+motif"

RDEPEND="
	!media-libs/mesa[motif]
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/motif:0
	virtual/opengl"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

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
