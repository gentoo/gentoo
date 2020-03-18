# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

MY_P="${P/emf/EMF}"
DESCRIPTION="Library implementation of ECMA-234 API for the generation of enhanced metafiles"
HOMEPAGE="http://libemf.sourceforge.net/"
SRC_URI="mirror://sourceforge/libemf/${MY_P}.tar.gz"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="amd64 -arm ppc ppc64 sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=( --enable-editing )
	autotools-utils_src_configure
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	autotools-utils_src_install
}
