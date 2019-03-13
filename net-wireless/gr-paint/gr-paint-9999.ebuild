# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/drmpeg/gr-paint.git"
else
	KEYWORDS=""
fi
inherit cmake-utils python-single-r1

DESCRIPTION="Paints monochrome images into the waterfall of a receiver"
HOMEPAGE="https://github.com/drmpeg/gr-paint"

LICENSE="GPL-3+"
SLOT="0"
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-libs/boost:=[${PYTHON_USEDEP}]
	net-wireless/gnuradio:=[${PYTHON_USEDEP}]
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
