# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libdap/libdap-3.11.3.ebuild,v 1.4 2012/08/03 19:37:27 bicatali Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="Implementation of a C++ SDK for DAP 2.0 and 3.2"
HOMEPAGE="http://opendap.org/"
SRC_URI="http://www.opendap.org/pub/source/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 URI )"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs test"

RDEPEND="
	dev-util/cppunit
	dev-libs/libxml2:2
	net-misc/curl
	sys-libs/zlib
"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"

DOCS=( README NEWS README.dodsrc )

RESTRICT="test"
# needs http connection
# FAIL: MIMEUtilTest

PATCHES=( "${FILESDIR}"/${P}-gcc-4.7.patch )

src_compile() {
	autotools-utils_src_compile
	use doc && autotools-utils_src_compile docs
}

src_test() {
	emake check
	cd "${S}"/unit-tests
	emake check
}

src_install() {
	use doc && HTML_DOCS=("${AUTOTOOLS_BUILD_DIR}/docs/html/")
	autotools-utils_src_install
}
