# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libp11/libp11-0.2.8-r3.ebuild,v 1.10 2015/07/30 12:31:49 ago Exp $

EAPI="5"

inherit eutils autotools

DESCRIPTION="A library implementing a layer on top of PKCS#11 API to make using PKCS#11 implementations easier"
HOMEPAGE="https://github.com/opensc/libp11/wiki"
SRC_URI="mirror://sourceforge/opensc/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE="doc"

RDEPEND="dev-libs/openssl:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-ltdl.patch
	epatch "${FILESDIR}"/${P}-variable-buffer-size.patch
	eautoreconf
}

src_configure() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		--htmldir="/usr/share/doc/${PF}/html" \
		--enable-shared --disable-static \
		--enable-doc \
		$(use_enable doc api-doc)
}

src_install() {
	default
	prune_libtool_files
}
