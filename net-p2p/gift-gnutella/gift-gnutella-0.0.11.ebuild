# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gift-gnutella/gift-gnutella-0.0.11.ebuild,v 1.12 2012/05/04 06:33:35 jdhore Exp $

inherit eutils

DESCRIPTION="The giFT Gnutella plugin"
HOMEPAGE="http://gift.sf.net/"
SRC_URI="mirror://sourceforge/gift/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ia64 ~ppc sparc x86 ~x86-fbsd"
IUSE="xml"

RDEPEND=">=net-p2p/gift-0.11.6"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/bzip2
	dev-libs/libxml2"

src_compile() {
	econf $(use_with xml libxml) || die "failed to configure"
	emake || die "failed to build"
}

src_install() {
	einstall giftconfdir="${D}"/etc/giFT \
		plugindir="${D}"/usr/$(get_libdir)/giFT \
		datadir="${D}"/usr/share \
		giftperldir="${D}"/usr/bin \
		libgiftincdir="${D}"/usr/include/libgift || die "einstall failed"
	newbin "${FILESDIR}"/cacheupdate.sh ${PN}-cacheupdate.sh
}

pkg_postinst() {
	elog "It is recommended that you re-run gift-setup as"
	elog "the user you will run the giFT daemon as:"
	elog "\tgift-setup"
	echo
	elog "Alternatively you can add the following line to"
	elog "your ~/.giFT/giftd.conf configuration file:"
	elog "plugins = Gnutella"
	echo
	elog "To update your caches, run:"
	elog "\t${PN}-cacheupdate.sh"
}
