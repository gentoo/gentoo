# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 python-single-r1

DESCRIPTION="A module adding spectral estimation routines to GNU Radio"
HOMEPAGE="https://github.com/kit-cel/gr-specest"
EGIT_REPO_URI="https://github.com/kit-cel/gr-specest.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=net-wireless/gnuradio-3.7.0:=[${PYTHON_SINGLE_USEDEP}]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

src_configure() {
	mycmakeargs=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake-utils_src_configure
}
