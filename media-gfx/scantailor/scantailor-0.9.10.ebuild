# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/scantailor/scantailor-0.9.10.ebuild,v 1.5 2013/03/02 21:40:28 hwoarang Exp $

EAPI=4
inherit cmake-utils eutils virtualx

DESCRIPTION="A interactive post-processing tool for scanned pages"
HOMEPAGE="http://scantailor.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 GPL-3 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl"

RDEPEND=">=media-libs/libpng-1.2.43
	>=media-libs/tiff-3.9.4
	sys-libs/zlib
	virtual/jpeg
	x11-libs/libXrender
	dev-qt/qtgui:4
	opengl? ( dev-qt/qtopengl:4 )"
DEPEND="${RDEPEND}
	dev-libs/boost"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.9-environment_flags.patch
	"${FILESDIR}"/${PN}-gcc46.patch
)

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable opengl)
	)

	cmake-utils_src_configure
}

src_test() {
	cd "${CMAKE_BUILD_DIR}" || die
	Xemake test
}

src_install() {
	cmake-utils_src_install

	newicon resources/appicon.svg ${PN}.svg
	make_desktop_entry ${PN} "Scan Tailor"
}
