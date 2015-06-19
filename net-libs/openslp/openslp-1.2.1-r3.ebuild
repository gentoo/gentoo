# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/openslp/openslp-1.2.1-r3.ebuild,v 1.9 2014/07/20 12:04:36 pacho Exp $

inherit eutils autotools systemd

DESCRIPTION="An open-source implementation of Service Location Protocol"
HOMEPAGE="http://www.openslp.org/"
SRC_URI="mirror://sourceforge/openslp/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""
RESTRICT="test"

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-fbsd.patch
	epatch "${FILESDIR}"/${P}-fixoverflow.patch
	epatch "${FILESDIR}"/${P}-cflags.patch
	eautoreconf
}

src_compile() {
	econf || die
	emake -j1 || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS FAQ ChangeLog NEWS README* THANKS
	rm -rf "${D}"/usr/doc
	dohtml -r .
	newinitd "${FILESDIR}"/slpd-init slpd
	systemd_dounit "${FILESDIR}"/slpd.service
}
