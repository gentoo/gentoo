# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Linux Virtual Server (LVS) addon for dynamic server health feedback"

HOMEPAGE="http://ozlabs.org/~jk/projects/feedbackd/"
LICENSE="GPL-2"
DEPEND="dev-libs/libxml2
	>=sys-cluster/ipvsadm-1.24
	dev-lang/perl"

SRC_URI="mirror://sourceforge/feedbackd/${P}.tar.gz"

IUSE=""
SLOT="0"
KEYWORDS="x86"

src_compile() {
	einfo "Note: feedbackd-master needs a kernel with ipvs support and with ipvs enabled"

	econf \
		--sysconfdir=/etc \
		--localstatedir=/var \
		|| die "bad ./configure"

	emake || die
}

src_install() {
	einstall || die
	dodoc ChangeLog NEWS README
}
