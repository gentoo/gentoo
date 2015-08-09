# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Apache C++ XML security libraries"
HOMEPAGE="http://santuario.apache.org/"
SRC_URI="mirror://apache/santuario/c-library/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug examples nss static-libs xalan"

RDEPEND=">=dev-libs/xerces-c-3.1
	dev-libs/openssl
	nss? ( dev-libs/nss )
	xalan? ( dev-libs/xalan-c )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( CHANGELOG.txt NOTICE.txt )

src_prepare() {
	epatch "${FILESDIR}/1.6.1-nss-compilation-fix.patch"
	epatch_user
}

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
		insinto /usr/share/doc/${PF}/examples
		doins xsec/samples/*.cpp
	fi
}
