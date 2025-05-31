# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VIRTUALX_REQUIRED="manual"
inherit cmake virtualx xdg

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/input-leap/input-leap.git"
	inherit git-r3
else
	SRC_URI="https://github.com/input-leap/input-leap/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~chewi/distfiles/${P}-no-x11.patch"
	KEYWORDS="amd64 ~x86"
fi

DESCRIPTION="Share a mouse and keyboard between computers (fork of Barrier)"
HOMEPAGE="https://github.com/input-leap/input-leap"

LICENSE="GPL-2"
SLOT="0"
IUSE="gui test +wayland +X"
REQUIRED_USE="|| ( wayland X )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/openssl:0=
	gui? (
		dev-qt/qtbase:6[gui,network,widgets]
		net-dns/avahi[mdnsresponder-compat]
	)
	wayland? (
		dev-libs/glib:2
		dev-libs/libei
		dev-libs/libportal:=
		x11-libs/libxkbcommon
	)
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXtst
	)
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	test? ( dev-cpp/gtest )
"
BDEPEND="
	virtual/pkgconfig
	gui? ( dev-qt/qttools:6[linguist] )
	test? ( X? ( ${VIRTUALX_DEPEND} ) )
"

PATCHES=(
	"${FILESDIR}"/${P}-gui-crash.patch
	"${DISTDIR}"/${P}-no-x11.patch
)

DOCS=(
	ChangeLog
	README.md
	doc/${PN}.conf.example{,-advanced,-basic}
)

src_configure() {
	local REV="${EGIT_VERSION:-00000000}"
	local mycmakeargs=(
		-DINPUTLEAP_BUILD_GUI=$(usex gui)
		-DINPUTLEAP_BUILD_LIBEI=$(usex wayland)
		-DINPUTLEAP_BUILD_TESTS=$(usex test)
		-DINPUTLEAP_BUILD_X11=$(usex X)
		-DINPUTLEAP_REVISION="${REV:0:8}"
		-DINPUTLEAP_USE_EXTERNAL_GTEST=ON
	)
	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/bin/unittests || die

	if use X; then
		virtx "${BUILD_DIR}"/bin/integtests
	else
		"${BUILD_DIR}"/bin/integtests || die
	fi
}
