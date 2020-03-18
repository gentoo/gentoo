# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib eapi7-ver

DESCRIPTION="Small, safe and fast formatting library"
HOMEPAGE="https://github.com/fmtlib/fmt"

LICENSE="BSD-2"
IUSE="test"
RESTRICT="!test? ( test )"
SLOT="0/$(ver_cut 1)"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/fmtlib/fmt.git"
	inherit git-r3
else
	SRC_URI="https://github.com/fmtlib/fmt/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ppc ppc64 x86"
	S="${WORKDIR}/fmt-${PV}"
fi

DEPEND=""
RDEPEND=""

multilib_src_configure() {
	local mycmakeargs=(
		-DFMT_CMAKE_DIR="$(get_libdir)/cmake/fmt"
		-DFMT_LIB_DIR="$(get_libdir)"
		-DFMT_TEST=$(usex test)
		-DBUILD_SHARED_LIBS=ON
	)
	cmake-utils_src_configure
}
