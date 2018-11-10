# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )
PYTHON_REQ_USE="threads(+)"
inherit python-any-r1 waf-utils

DESCRIPTION="small C++ library which makes it marginally neater to parse XML using libxml++"
HOMEPAGE="http://carlh.net/libcxml"
SRC_URI="http://carlh.net/downloads/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-cpp/libxmlpp:2.6
	dev-libs/boost
	dev-libs/locked_sstream"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/waf
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-0.15.1-respect-cxxflags.patch )

src_prepare() {
	rm -v waf || die
	export WAF_BINARY="${EROOT}usr/bin/waf"

	default
}

src_test() {
	./run-tests.sh || die
}
