# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )
PYTHON_REQ_USE="threads(+)"
inherit python-any-r1 waf-utils

DESCRIPTION="implementation of SMPTE and the MXF Interop Sound & Picture Track File format"
HOMEPAGE="http://carlh.net/asdcplib"
SRC_URI="http://carlh.net/downloads/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/boost
	dev-libs/openssl:0"
DEPEND="${RDEPEND}
	dev-util/waf
	virtual/pkgconfig
	${PYTHON_DEPS}"

PATCHES=( "${FILESDIR}"/${PN}-0.1.1-no-ldconfig.patch
	"${FILESDIR}"/${PN}-0.1.2-respect-cxxflags.patch)

src_prepare() {
	rm -r waf aclocal.m4 m4 configure{,.ac} Makefile.{am,in} || die
	export WAF_BINARY=${EROOT}usr/bin/waf

	default
}
