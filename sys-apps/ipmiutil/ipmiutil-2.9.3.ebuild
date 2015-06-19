# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ipmiutil/ipmiutil-2.9.3.ebuild,v 1.3 2014/06/28 17:59:02 jer Exp $

EAPI=4
inherit autotools eutils systemd

DESCRIPTION="IPMI Management Utilities"
HOMEPAGE="http://ipmiutil.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

RDEPEND=">=dev-libs/openssl-1:0"
DEPEND="${RDEPEND}
	virtual/os-headers"

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch
	epatch "${FILESDIR}"/${P}-tmpdir.patch

	sed -i -e 's|-O2 -g|$(CFLAGS)|g;s|-g -O2|$(CFLAGS)|g' util/Makefile.am* || die

	eautoreconf
}

src_configure() {
	econf --disable-systemd --enable-sha256
}

src_install() {
	emake DESTDIR="${D}" sysdto="${D}/$(systemd_get_unitdir)" install
	dodoc -r AUTHORS ChangeLog NEWS README TODO doc/UserGuide

	rm -r "${ED}"/etc/init.d || die 'remove initscripts failed' # These are only for Fedora
}
