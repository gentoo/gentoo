# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils virtualx toolchain-funcs versionator
MY_PV="RELEASE_$(replace_all_version_separators _)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A interactive post-processing tool for scanned pages"
HOMEPAGE="http://scantailor.sourceforge.net/"
SRC_URI="https://github.com/scantailor/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 GPL-3 public-domain"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="opengl"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-libs/libpng:0
	media-libs/tiff:0
	sys-libs/zlib
	virtual/jpeg:0
	x11-libs/libXrender
	opengl? ( dev-qt/qtopengl:4 )"
DEPEND="${RDEPEND}
	dev-libs/boost"

S="${WORKDIR}/${PN}-${MY_PV}"

src_configure() {
	tc-export CXX

	local mycmakeargs=(
		-DCOMPILER_FLAGS_OVERRIDDEN=ON
		-DENABLE_OPENGL=$(usex opengl)
	)

	cmake-utils_src_configure
}

src_test() {
	cd "${CMAKE_BUILD_DIR}" || die
	virtx emake test
}

src_install() {
	cmake-utils_src_install

	newicon resources/appicon.svg ${PN}.svg
	make_desktop_entry ${PN} "Scan Tailor"
}
