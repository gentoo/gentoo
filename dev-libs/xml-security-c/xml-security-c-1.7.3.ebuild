# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Apache C++ XML security libraries"
HOMEPAGE="http://santuario.apache.org/"
SRC_URI="mirror://apache/santuario/c-library/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug examples libressl nss static-libs xalan"

RDEPEND=">=dev-libs/xerces-c-3.1
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	nss? ( dev-libs/nss )
	xalan? ( dev-libs/xalan-c )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( CHANGELOG.txt NOTICE.txt )
PATCHES=(
	"${FILESDIR}/${PN}-1.6.1-nss-compilation-fix.patch"
	"${FILESDIR}/${PN}-1.7.3-fix-c++14.patch"
)

src_configure() {
	econf \
		--with-openssl \
		$(use_enable static-libs static) \
		$(use_enable debug) \
		$(use_with xalan) \
		$(use_with nss)
}

src_install() {
	default
	if use examples ; then
		docinto examples
		dodoc xsec/samples/*.cpp
	fi
}
