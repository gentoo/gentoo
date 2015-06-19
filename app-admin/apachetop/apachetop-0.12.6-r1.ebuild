# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/apachetop/apachetop-0.12.6-r1.ebuild,v 1.7 2013/07/09 18:29:20 neurogeek Exp $

EAPI="2"

inherit eutils autotools

DESCRIPTION="A realtime Apache log analyzer"
HOMEPAGE="http://www.webta.org/projects/apachetop"
SRC_URI="http://www.webta.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~mips ppc sparc x86"
IUSE="fam pcre adns"

DEPEND="fam? ( virtual/fam )
	pcre? ( dev-libs/libpcre )
	adns? ( net-libs/adns )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc41.patch
	epatch "${FILESDIR}"/${P}-configure.patch
	epatch "${FILESDIR}"/${P}-maxpathlen.patch
	epatch "${FILESDIR}"/${P}-ac_config_header.patch
	eautoreconf
}

src_configure() {
	econf --with-logfile=/var/log/apache2/access_log \
		$(use_with fam) \
		$(use_with pcre) \
		$(use_with adns)
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}
