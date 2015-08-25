# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit git-r3
inherit cmake-utils python-single-r1

DESCRIPTION="paints monochrome images into the waterfall of a receiver"
HOMEPAGE="https://github.com/drmpeg/gr-paint"
SRC_URI=""
EGIT_REPO_URI="https://github.com/drmpeg/gr-paint.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
		net-wireless/gnuradio:=[${PYTHON_USEDEP}]
		dev-libs/boost:=[${PYTHON_USEDEP}]"
RDEPEND="${COMMON_DEPEND}
	media-gfx/imagemagick"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	dev-util/cppunit
	dev-lang/swig
	doc? ( app-doc/doxygen )"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable doc DOXYGEN)
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake-utils_src_configure
}
