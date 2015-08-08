# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils flag-o-matic eutils

MY_P=zpaq${PV/./}
DESCRIPTION="Library to compress files in the ZPAQ format"
HOMEPAGE="http://mattmahoney.net/dc/zpaq.html"
SRC_URI="http://mattmahoney.net/dc/${MY_P}.zip"

LICENSE="zpaq"
SLOT="0/4"
KEYWORDS="~amd64 ~x86"
IUSE="debug +jit static-libs"

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

src_prepare() {
	EPATCH_OPTS+=-p1 epatch "${FILESDIR}"/0001-Add-autotools-files.patch
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-library-version=${SLOT#*/}:0:0
	)

	use debug || append-cppflags -DNDEBUG
	use jit || append-cppflags -DNOJIT

	autotools-utils_src_configure
}
