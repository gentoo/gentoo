# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )

inherit cmake-utils python-any-r1

DESCRIPTION="CommonMark parsing and rendering library and program in C"
HOMEPAGE="https://github.com/jgm/cmark"
SRC_URI="https://github.com/jgm/cmark/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	test? ( ${PYTHON_DEPS} )"
RDEPEND=""

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare
	# Remove static library from installing
	sed -i -e \
		s":\${LIBRARY} \${STATICLIBRARY}:\${LIBRARY}:g" \
		src/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCMARK_TESTS="$(usex test)"
	)
	cmake-utils_src_configure
}
