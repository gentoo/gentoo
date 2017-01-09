# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="CommonMark parsing and rendering library and program in C"
HOMEPAGE="https://github.com/jgm/cmark"
SRC_URI="https://github.com/jgm/cmark/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	test? ( || ( dev-lang/python:3.4 dev-lang/python:3.5 ) )"
RDEPEND=""

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
