# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/engine_pkcs11/engine_pkcs11-0.1.8.ebuild,v 1.8 2012/05/04 18:35:51 jdhore Exp $

EAPI="2"

if [[ "${PV}" = "9999" ]]; then
	inherit autotools subversion
	ESVN_REPO_URI="http://www.opensc-project.org/svn/${PN}/trunk"
else
	SRC_URI="http://www.opensc-project.org/files/${PN}/${P}.tar.gz"
fi

DESCRIPTION="engine_pkcs11 is an implementation of an engine for OpenSSL"
HOMEPAGE="http://www.opensc-project.org/engine_pkcs11"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=dev-libs/libp11-0.2.5
	>=dev-libs/openssl-0.9.7d:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

if [[ "${PV}" = "9999" ]]; then
	DEPEND="${DEPEND}
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt"

	src_prepare() {
		eautoreconf
	}
fi

src_configure() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		--htmldir="/usr/share/doc/${PF}/html" \
		--disable-static --enable-shared \
		--enable-doc
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
}
