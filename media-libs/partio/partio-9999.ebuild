# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit cmake-utils vcs-snapshot python-single-r1

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wdas/partio.git"
else
	MY_GIT_COMMIT="2774ef3958da46d9f8a4230ebda9e04b1aa8f4e5"
	SRC_URI="https://github.com/wdas/${PN}/archive/${MY_GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library for particle IO and manipulation"
HOMEPAGE="https://www.disneyanimation.com/technology/partio.html"

LICENSE="BSD"
SLOT="0"
IUSE="doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	media-libs/freeglut
	virtual/opengl
	sys-libs/zlib:="

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[latex] )
	dev-lang/swig:*"

src_prepare() {
	cmake-utils_src_prepare
	cmake_comment_add_subdirectory "src/tests"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package doc Doxygen)
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
	)
	cmake-utils_src_configure
}
