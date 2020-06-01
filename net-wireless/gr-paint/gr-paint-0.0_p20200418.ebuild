# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/drmpeg/gr-paint.git"
else
	COMMIT="e36b2c638061d14f1b3c3bf3e889a8c99c273930"
	SRC_URI="https://github.com/drmpeg/gr-paint/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64"
fi
inherit cmake-utils python-single-r1

DESCRIPTION="Paints monochrome images into the waterfall of a receiver"
HOMEPAGE="https://github.com/drmpeg/gr-paint"

LICENSE="GPL-3+"
SLOT="0"
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-libs/boost:=[${PYTHON_MULTI_USEDEP}]
	')
	=net-wireless/gnuradio-3.7*:=[${PYTHON_SINGLE_USEDEP}]
"
RDEPEND="${DEPEND}
	media-gfx/imagemagick
"
BDEPEND="
	dev-lang/swig
	dev-util/cppunit
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOXYGEN=$(usex doc)
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake-utils_src_configure
}
