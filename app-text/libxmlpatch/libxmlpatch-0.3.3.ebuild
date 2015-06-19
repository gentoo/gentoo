# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/libxmlpatch/libxmlpatch-0.3.3.ebuild,v 1.4 2012/05/04 03:33:13 jdhore Exp $

EAPI=4

inherit eutils autotools

DESCRIPTION="A set of tools to create and apply patch to XML files using XPath"
HOMEPAGE="http://xmlpatch.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN/lib}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test static-libs"

RDEPEND="dev-libs/glib:2
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with test check)
}

DOCS=( LEGAL_NOTICE README TODO ChangeLog )

src_install() {
	default

	find "${D}" -name '*.la' -delete
}
