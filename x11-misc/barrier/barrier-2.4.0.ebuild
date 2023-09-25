# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop virtualx xdg cmake

DESCRIPTION="Share a mouse and keyboard between computers (fork of Synergy)"
HOMEPAGE="https://github.com/debauchee/barrier"
SRC_URI="https://github.com/debauchee/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gui test"
RESTRICT="!test? ( test )"

RDEPEND="
	net-misc/curl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXtst
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		net-dns/avahi[mdnsresponder-compat]
	)
	dev-libs/openssl:0=
"
DEPEND="
	${RDEPEND}
	dev-cpp/gtest
	dev-cpp/gulrak-filesystem
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}"/${P}-includes.patch
	"${FILESDIR}"/${P}-gcc-13.patch
)

DOCS=(
	ChangeLog
	README.md
	doc/${PN}.conf.example{,-advanced,-basic}
)

src_configure() {
	local mycmakeargs=(
		-DBARRIER_BUILD_GUI=$(usex gui)
		-DBARRIER_BUILD_INSTALLER=OFF
		-DBARRIER_BUILD_TESTS=$(usex test)
		-DBARRIER_REVISION=00000000
		-DBARRIER_USE_EXTERNAL_GTEST=ON
		-DBARRIER_VERSION_STAGE=gentoo
	)

	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/bin/unittests || die
	virtx "${BUILD_DIR}"/bin/integtests || die
}

src_install() {
	cmake_src_install
	einstalldocs
	doman doc/${PN}{c,s}.1

	if use gui; then
		doicon -s scalable res/${PN}.svg
		doicon -s 256 res/${PN}.png
		make_desktop_entry ${PN} Barrier ${PN} Utility
	fi
}
