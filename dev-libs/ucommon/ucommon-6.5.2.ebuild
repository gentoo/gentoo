# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils eutils

DESCRIPTION="Portable C++ runtime for threads and sockets"
HOMEPAGE="http://www.gnu.org/software/commoncpp"
SRC_URI="mirror://gnu/commoncpp/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/6"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE="doc static-libs socks +cxx debug ssl gnutls"

RDEPEND="
	ssl? (
		!gnutls? ( dev-libs/openssl:0= )
		gnutls? (
			net-libs/gnutls:0=
			dev-libs/libgcrypt:0=
		)
	)"

DEPEND="virtual/pkgconfig
	doc? ( app-doc/doxygen )
	${RDEPEND}"

DOCS=(README NEWS SUPPORT ChangeLog AUTHORS)
PATCHES=(
	"${FILESDIR}/6.1/install_gcrypt.m4_file.patch"
	"${FILESDIR}/${PN}-6.3.1-gcrypt_autotools.patch"
)

# Needed for doxygen, bug #526726
AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	# Aclocal 1.13 deprecated error BGO #467674
	sed -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' -i configure.ac || die

	# don't install latex and rtf documents
	sed -e '/^GENERATE_LATEX/s@YES@NO@' -e '/^GENERATE_RTF/s@YES@NO@' \
		-i Doxyfile.in || die

	autotools-utils_src_prepare
}

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
