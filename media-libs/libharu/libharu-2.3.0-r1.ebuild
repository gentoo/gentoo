# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libharu/libharu-2.3.0-r1.ebuild,v 1.5 2015/02/25 15:28:56 ago Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils multilib-minimal

MYP=RELEASE_${PV//./_}

DESCRIPTION="C/C++ library for PDF generation"
HOMEPAGE="http://www.libharu.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${MYP}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="png static-libs zlib"

DEPEND="
	png? ( >=media-libs/libpng-1.2.51[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MYP}"

PATCHES=( "${FILESDIR}"/${P}-dont-force-strip.patch )

multilib_src_configure() {
	local myeconfargs=(
		$(use_with png png "${EPREFIX}"/usr)
		$(use_with zlib)
	)
	autotools-utils_src_configure
}
