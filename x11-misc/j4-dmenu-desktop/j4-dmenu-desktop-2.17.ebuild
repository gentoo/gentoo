# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_PV="r${PV}"

DESCRIPTION="A fast desktop replacement for i3-dmenu-desktop"
HOMEPAGE="https://github.com/enkore/j4-dmenu-desktop"
SRC_URI="https://github.com/enkore/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/catch:1 )"
RDEPEND="x11-misc/dmenu"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	cmake-utils_src_prepare

	# Respect users CFLAGS
	sed -i -e "s/-pedantic -O2//" CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DWITH_GIT_CATCH="no"
		-DWITH_TESTS=$(usex test)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	doman j4-dmenu-desktop.1
}
