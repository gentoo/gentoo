# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_PV="r${PV}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A fast desktop menu"
HOMEPAGE="https://github.com/enkore/j4-dmenu-desktop"
SRC_URI="https://github.com/enkore/j4-dmenu-desktop/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-cpp/catch:1 )"
RDEPEND="x11-misc/dmenu"

S="${WORKDIR}/${MY_P}"

# Merged upstream; remove in next version bump
PATCHES=( "${FILESDIR}/${P}_system_catch.patch" )

src_prepare() {
	cmake-utils_src_prepare
	sed -i -e "s/-pedantic -O2//" CMakeLists.txt || die "sed failed"
}

src_configure() {
	local mycmakeargs=(
		-DWITH_TESTS=$(usex test)
		-DWITH_GIT_CATCH=no
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doman "j4-dmenu-desktop.1"
}
