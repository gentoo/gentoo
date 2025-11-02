# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fantasy adventure game, based on the works of J.R.R. Tolkien"
HOMEPAGE="https://github.com/tome2/tome2"
MY_COMMIT="3892fbcb1c2446afcb0c34f59e2a24f78ae672c4"
SRC_URI="https://github.com/tome2/tome2/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/tome2-${MY_COMMIT}"

LICENSE="Moria ToME2-theme"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

RDEPEND="
	dev-libs/boost:=
	dev-libs/libfmt:=
	sys-libs/ncurses:=
	X? ( x11-libs/libX11 )
"
DEPEND="
	${RDEPEND}
	dev-cpp/jsoncons
	dev-cpp/pcg-cpp
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/tome-2.4.0-json.patch"
	"${FILESDIR}/tome-2.4.0-datadir.patch"
	"${FILESDIR}/tome-2.4.0-order.patch"
	"${FILESDIR}/tome-2.4.0-boost.patch"
	"${FILESDIR}/tome-2.4.0-cmake4.patch"
	"${FILESDIR}/tome-2.4.0-header.patch"
	"${FILESDIR}/tome-2.4.0-fmt.patch"
)

src_prepare() {
	# The rest of bundled deps are test-only and very old
	rm -r vendor/fmt* vendor/jsoncons* vendor/pcg-cpp* || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSYSTEM_INSTALL=yes
		-DBUILD_SHARED_LIBS=no
		-DCMAKE_DISABLE_FIND_PACKAGE_X11=$(usex !X)
		-DCMAKE_DISABLE_FIND_PACKAGE_GTK2=yes
	)
	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/src/harness || die
}
