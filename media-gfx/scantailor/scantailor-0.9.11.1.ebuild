# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit cmake-utils eutils virtualx toolchain-funcs

DESCRIPTION="A interactive post-processing tool for scanned pages"
HOMEPAGE="http://scantailor.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${P}-boost-join-moc.patch"

LICENSE="GPL-2 GPL-3 public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
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

src_prepare() {
	epatch -p1 \
		"${DISTDIR}/${P}-boost-join-moc.patch" \
		"${FILESDIR}/${P}-boost-lambda-namespace.patch"
}

src_configure() {
	tc-export CXX

	mycmakeargs=(
		-DCOMPILER_FLAGS_OVERRIDDEN=ON
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
