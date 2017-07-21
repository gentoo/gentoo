# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )
PYTHON_REQ_USE="threads(+)"
inherit python-any-r1 waf-utils

DESCRIPTION="read and write subtitles in a few different formats"
HOMEPAGE="http://carlh.net/libsub"
SRC_URI="http://carlh.net/downloads/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="1.0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-cpp/glibmm:2
	dev-cpp/libxmlpp:2.6
	dev-libs/boost:=
	>=dev-libs/libcxml-0.15.4
	dev-libs/openssl:0
	>=media-libs/libasdcp-cth-0.1.3"
DEPEND="${RDEPEND}
	dev-util/waf
	virtual/pkgconfig
	${PYTHON_DEPS}"

PATCHES=( "${FILESDIR}"/${PN}-1.2.4-no-ldconfig.patch
	"${FILESDIR}"/${PN}-1.1.13-respect-cxxflags.patch )

src_prepare() {
	rm -v waf || die
	export WAF_BINARY=${EROOT}usr/bin/waf

	ewarn "Some tests failing due missing files/certs are disabled."
	sed -e '/ssa_reader_test.cc/d' \
		-e '/dcp_to_stl_binary_test.cc/d' \
		-i test/wscript || die

	default
}

src_test() {
	./run/tests || die
}
