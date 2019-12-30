# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_5,3_6} )
inherit cmake python-single-r1

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wdas/partio.git"
else
	SRC_URI="https://github.com/wdas/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Library for particle IO and manipulation"
HOMEPAGE="https://www.disneyanimation.com/technology/partio.html"

LICENSE="BSD"
SLOT="0"
IUSE="doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	dev-lang/swig
	doc? ( app-doc/doxygen[latex] )
"
RDEPEND="${PYTHON_DEPS}
	media-libs/freeglut
	sys-libs/zlib
	virtual/opengl
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package doc Doxygen)
	)
	cmake_src_configure
}
