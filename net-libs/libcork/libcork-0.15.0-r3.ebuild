# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit cmake python-any-r1

DESCRIPTION="Simple, easily embeddable cross-platform C library"
HOMEPAGE="https://github.com/dcreager/libcork"
SRC_URI="https://github.com/dcreager/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="static-libs"

RDEPEND="dev-libs/check"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-git.patch"
	"${FILESDIR}/${P}-version.patch"
)

CMAKE_SKIP_TESTS=( shared-test-files )

src_prepare() {
	if ! [[ -e ${S}/RELEASE-VERSION ]] ; then
		echo ${PV} > "${S}"/RELEASE-VERSION || die
	fi
	sed -i -e "s/-Werror/-Wextra/" \
		-e "/docs\/old/d" \
		-e "/cmake_minimum_required/s/2.6/3.10/" \
		CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATIC=$(usex static-libs)
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake_src_configure
}
