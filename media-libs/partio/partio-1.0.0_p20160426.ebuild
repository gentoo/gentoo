# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit cmake-utils vcs-snapshot python-single-r1

DESCRIPTION="A library for particle IO and manipulation"
HOMEPAGE="http://www.disneyanimation.com/technology/partio.html"

MY_GIT_COMMIT="7f3e0d19e1931a591f53d4485bfffc665724a967"
SRC_URI="https://github.com/wdas/partio/archive/${MY_GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	media-libs/freeglut
	virtual/opengl
	sys-libs/zlib
	media-libs/SeExpr"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[latex] )
	dev-lang/swig:*"

src_prepare() {
	cmake-utils_src_prepare

	sed -e '/ADD_SUBDIRECTORY (src\/tests)/d' -i CMakeLists.txt || die
	sed -e "s|doc/partio|doc/${PF}|" -i src/doc/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=( $(cmake-utils_use_find_package doc Doxygen) )

	cmake-utils_src_configure
}
