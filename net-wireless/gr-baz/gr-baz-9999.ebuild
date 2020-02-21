# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/balint256/gr-baz.git"
else
	KEYWORDS=""
fi
inherit cmake-utils python-single-r1

DESCRIPTION="Gnuradio baz"
HOMEPAGE="https://wiki.spench.net/wiki/Gr-baz"

LICENSE="GPL-3"
SLOT="0"
IUSE="armadillo doc rtlsdr uhd"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-libs/boost:=[threads,${PYTHON_MULTI_USEDEP}]
	')
	>=net-wireless/gnuradio-3.7.0:=[${PYTHON_SINGLE_USEDEP}]
	armadillo? ( sci-libs/armadillo )
	rtlsdr? ( virtual/libusb:1 )
	uhd? ( net-wireless/uhd[${PYTHON_SINGLE_USEDEP}] )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	local mycmakeargs=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake-utils_src_configure
}
src_install() {
	cmake-utils_src_install
	insinto /usr/share/${PN}
	doins -r samples/*
}
