# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fantasy adventure game, based on the works of J.R.R. Tolkien"
HOMEPAGE="https://github.com/tome2/tome2"
MY_COMMIT="8e2f6361e1a55b21e7abcf051e47a22761d41471"
SRC_URI="https://github.com/tome2/tome2/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/tome2-${MY_COMMIT}"

LICENSE="Moria ToME2-theme"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

RDEPEND="
	dev-libs/boost:=
	>=dev-libs/libfmt-12:=
	sys-libs/ncurses:=
	X? ( x11-libs/libX11 )
"
DEPEND="
	${RDEPEND}
	<dev-cpp/jsoncons-1.5.0
	dev-cpp/pcg-cpp
"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DSYSTEM_INSTALL=yes
		-DBUILD_SHARED_LIBS=no
		-DCMAKE_DISABLE_FIND_PACKAGE_X11=$(usex !X)
		-DCMAKE_DISABLE_FIND_PACKAGE_GTK2=yes
		-DCPM_LOCAL_PACKAGES_ONLY=yes
		-DUSE_SYSTEM_PCG_RANDOM=yes
	)
	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/src/harness || die
}
