# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/peephole/peephole-1.5.ebuild,v 1.3 2012/03/09 09:40:39 phajdan.jr Exp $

EAPI="4"

inherit eutils

DESCRIPTION="A daemon that polls your POP servers, checking if there are messages from specific people"
HOMEPAGE="http://peephole.sourceforge.net/"
SRC_URI="mirror://sourceforge/peephole/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"
IUSE="static-libs"

RDEPEND=">=dev-libs/openssl-0.9.7d-r1"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.4-gcc4.patch
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

pkg_postinst() {
	elog "Before you can use peephole you must copy"
	elog "/etc/skel/.peephole.providers and /etc/skel/.peepholerc"
	elog "to your home dir and edit them to suit your needs."
}
