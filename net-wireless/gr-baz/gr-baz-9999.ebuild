# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/gr-baz/gr-baz-9999.ebuild,v 1.3 2015/05/05 04:36:35 zerochaos Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 python-single-r1

DESCRIPTION="Gnuradio baz"
HOMEPAGE="http://wiki.spench.net/wiki/Gr-baz"
EGIT_REPO_URI="https://github.com/balint256/gr-baz.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="armadillo doc rtlsdr uhd"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="dev-libs/boost[threads,${PYTHON_USEDEP}]
	>=net-wireless/gnuradio-3.7.0:=[${PYTHON_USEDEP}]
	armadillo? ( sci-libs/armadillo )
	rtlsdr? ( virtual/libusb:1 )
	uhd? ( net-wireless/uhd[${PYTHON_USEDEP}] )
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
src_install() {
	cmake-utils_src_install
	insinto /usr/share/${PN}
	doins -r samples/*
}
