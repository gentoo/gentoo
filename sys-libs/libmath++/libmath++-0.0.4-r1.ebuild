# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1 # bug #474098
inherit autotools-utils

DESCRIPTION="template based math library, written in C++, for symbolic and numeric calculus applications"
HOMEPAGE="http://rm-rf.in/libmath%2B%2B/"
SRC_URI="http://upstream.rm-rf.in/libmath%2B%2B/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="amd64 ppc ~s390 x86"
IUSE="doc static-libs"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

DOCS=( AUTHORS README TODO )

src_prepare() {
	# Autotools 1.13 compatibility, bug #471950
	sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' configure.in || die 'sed on configure.in failed'

	autotools-utils_src_prepare
}

src_compile() {
	autotools-utils_src_compile

	if use doc; then
		pushd "${AUTOTOOLS_BUILD_DIR}" >/dev/null
		emake -C doc api-doc
		popd >/dev/null
	fi
}

src_install() {
	autotools-utils_src_install

	if use doc; then
		pushd "${AUTOTOOLS_BUILD_DIR}" >/dev/null
		dohtml -r doc/user-api/*
		popd >/dev/null
	fi
}
