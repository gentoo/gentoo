# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils eutils

MY_P="antlr-${PV}"
DESCRIPTION="The ANTLR3 C Runtime"
HOMEPAGE="https://github.com/antlr/antlr3/tree/master/runtime/C"
SRC_URI="https://github.com/antlr/antlr3/archive/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug debugger doc static-libs"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

S="${WORKDIR}/antlr3-${MY_P}/runtime/C"

DOCS=( AUTHORS ChangeLog NEWS README )
PATCHES=( "${FILESDIR}/${PN}-3.3-cflags.patch" )

src_prepare() {
	sed -i -e '/^QUIET/s/NO/YES/' doxyfile || die 'sed on doxyfile failed'

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable debug debuginfo)
		$(use_enable debugger antlrdebug)
	)
	if use amd64 || use ia64; then
		myeconfargs+=( --enable-64bit )
	else
		myeconfargs+=( --disable-64bit )
	fi

	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile

	if use doc; then
		einfo "Generating documentation API ..."
		doxygen -u doxyfile
		doxygen doxyfile || die "doxygen failed"
	fi
}

src_install() {
	autotools-utils_src_install

	if use doc; then
		dohtml api/*
	fi
}
