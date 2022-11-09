# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION="Small, safe and fast formatting library"
HOMEPAGE="https://github.com/fmtlib/fmt"

LICENSE="MIT"
IUSE="test"
SLOT="0/${PV}"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/fmtlib/fmt.git"
	inherit git-r3
else
	SRC_URI="https://github.com/fmtlib/fmt/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv x86"
	S="${WORKDIR}/fmt-${PV}"
fi

DEPEND=""
RDEPEND=""
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${P}-fix-static-assert.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DFMT_CMAKE_DIR="$(get_libdir)/cmake/fmt"
		-DFMT_LIB_DIR="$(get_libdir)"
		-DFMT_TEST=$(usex test)
	)
	cmake_src_configure
}
