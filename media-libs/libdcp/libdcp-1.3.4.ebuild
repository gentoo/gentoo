# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_3 python3_4 python3_5 )
PYTHON_REQ_USE="threads(+)"
inherit python-any-r1 waf-utils

DESCRIPTION="create and read Digital Cinema Packages using JPEG2000 and WAV files"
HOMEPAGE="http://carlh.net/libdcp"
SRC_URI="http://carlh.net/downloads/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="1.0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="dev-cpp/glibmm:2
	dev-cpp/libxmlpp:2.6
	>=dev-libs/boost-1.61.0
	<dev-libs/libcxml-0.15.4
	dev-libs/libsigc++:2
	dev-libs/libxml2
	dev-libs/openssl:0
	dev-libs/xmlsec
	media-libs/libasdcp-cth
	media-libs/openjpeg:0
	|| ( media-gfx/graphicsmagick media-gfx/imagemagick )"
DEPEND="${RDEPEND}
	dev-util/waf
	virtual/pkgconfig
	${PYTHON_DEPS}
	test? ( app-text/xmldiff )"

PATCHES=( "${FILESDIR}"/${PN}-1.3.3-no-ldconfig.patch
	"${FILESDIR}"/${PN}-1.3.4-respect-cxxflags.patch )

src_prepare() {
	rm -v waf || die
	export WAF_BINARY=${EROOT}usr/bin/waf

	ewarn "Some tests failing due missing files/certs are disabled."
	sed -e '/atmos_test.cc/d' \
		-e '/certificates_test.cc/d' \
		-e '/dcp_test.cc/d' \
		-e '/decryption_test.cc/d' \
		-e '/read_smpte_subtitle_test.cc/d' \
		-e '/sound_frame_test.cc/d' \
		-i test/wscript || die

	default
}

src_test() {
	./build/test/tests || die
}
