# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit cmake-utils vcs-snapshot python-single-r1

DESCRIPTION="A library for particle IO and manipulation"
HOMEPAGE="https://www.disneyanimation.com/technology/partio.html"

MY_GIT_COMMIT="2774ef3958da46d9f8a4230ebda9e04b1aa8f4e5"
SRC_URI="https://github.com/wdas/${PN}/archive/${MY_GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	media-libs/freeglut
	virtual/opengl
	sys-libs/zlib:=
"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[latex] )
	dev-lang/swig:*
"

PATCHES=( "${FILESDIR}/${PN}-1.1.0-Rename-partconv.patch" )

src_prepare() {
	cmake-utils_src_prepare

	sed -e '/ADD_SUBDIRECTORY (src\/tests)/d' -i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package doc Doxygen)
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
	)

	cmake-utils_src_configure
}
