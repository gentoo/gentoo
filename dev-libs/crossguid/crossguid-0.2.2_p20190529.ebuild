# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo cmake

MY_COMMIT="ca1bf4b810e2d188d04cb6286f957008ee1b7681"

DESCRIPTION="Lightweight cross platform C++ GUID/UUID library"
HOMEPAGE="https://github.com/graeme-hill/crossguid"
SRC_URI="https://github.com/graeme-hill/crossguid/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

# We use libuuid from util-linux.
DEPEND="sys-apps/util-linux"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.2_p20190529-gcc-13.patch
)

src_prepare() {
	# https://github.com/graeme-hill/crossguid/pull/62
	sed -i -e 's:-Werror::' CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCROSSGUID_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	edo "${BUILD_DIR}"/crossguid-test
}

src_install() {
	cmake_src_install

	rm "${ED}"/usr/share/crossguid/LICENSE || die
}
