# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools-utils eutils

DESCRIPTION="Portable C++ runtime for threads and sockets"
HOMEPAGE="https://www.gnu.org/software/commoncpp"
SRC_URI="mirror://gnu/commoncpp/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux"
IUSE="doc static-libs socks +cxx debug ssl gnutls"

RDEPEND="ssl? (
		!gnutls? ( dev-libs/openssl )
		gnutls? (
			net-libs/gnutls[-nettle]
			dev-libs/libgcrypt:0
		)
	)"

DEPEND="virtual/pkgconfig
	doc? ( app-doc/doxygen )
	${RDEPEND}"

DOCS=(README NEWS SUPPORT ChangeLog AUTHORS)
PATCHES=( "${FILESDIR}"/disable_rtf_gen_doxy.patch
		  "${FILESDIR}/${P}-address.patch")
AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	local myconf=""
	if use ssl; then
		myconf+=" --with-sslstack=$(usex gnutls gnu ssl) "
	else
		myconf+=" --with-sslstack=nossl ";
	fi

	local myeconfargs=(
		$(use_enable  socks)
		$(use_enable  cxx stdcpp)
		${myconf}
		--enable-atomics
		--with-pkg-config
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use doc && autotools-utils_src_compile doxy
}

src_install() {
	autotools-utils_src_install
	if use doc; then
		dohtml doc/html/*
	fi
}
