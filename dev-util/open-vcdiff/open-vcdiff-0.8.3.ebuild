# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

DESCRIPTION="An encoder/decoder for the VCDIFF (RFC3284) format"
HOMEPAGE="https://code.google.com/p/open-vcdiff/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-cpp/gflags
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_prepare() {
	rm -r gflags/src gtest src/zlib || die
	local PATCHES=( "${FILESDIR}/0.8.3-system-libs.patch" )
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-shared
		--disable-static
	)
	autotools-utils_src_configure
}
