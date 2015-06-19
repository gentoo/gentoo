# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/yaz/yaz-3.0.36.ebuild,v 1.2 2012/05/04 18:35:44 jdhore Exp $

inherit eutils autotools

DESCRIPTION="C/C++ programmer's toolkit supporting the development of Z39.50v3 clients and servers"
HOMEPAGE="http://www.indexdata.dk/yaz"
SRC_URI="http://ftp.indexdata.dk/pub/${PN}/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="debug icu tcpd ziffy"

RDEPEND="dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/openssl
	icu? ( dev-libs/icu )
	tcpd? ( sys-apps/tcp-wrappers )
	ziffy? ( net-libs/libpcap )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-lang/tcl"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-3.0.26-icu-automagic.patch
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	econf \
		--enable-static \
		--enable-shared \
		$(use_enable debug memdebug) \
		$(use_enable icu) \
		$(use_enable tcpd tcpd /usr)

	emake || die "emake failed"
}

src_install() {
	local docdir="/usr/share/doc/${PF}"
	emake DESTDIR="${D}" docdir="${docdir}" install || die "install failed"

	dodir ${docdir}/html
	mv -f "${D}"/${docdir}/*.{html,png} "${D}"/${docdir}/html/ || die "Failed to move HTML docs"
	mv -f "${D}"/usr/share/doc/${PN}/common "${D}"/${docdir}/html/ || die "Failed to move HTML docs"
	rm -rf "${D}"/usr/share/doc/${PN}

	dodoc ChangeLog NEWS README TODO
}
