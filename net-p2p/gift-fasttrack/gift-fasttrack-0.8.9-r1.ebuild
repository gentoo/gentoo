# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit multilib

IUSE=""

MY_P=${P/gift-fasttrack/giFT-FastTrack}

DESCRIPTION="FastTrack Plugin for giFT"
HOMEPAGE="https://developer.berlios.de/projects/gift-fasttrack/"
#SRC_URI="mirror://berlios/${PN}/${MY_P}.tar.gz"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ia64 ~ppc sparc x86 ~x86-fbsd"

RDEPEND=">=net-p2p/gift-0.11.1"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	make DESTDIR=${D} \
		giftconfdir=/etc/giFT \
		plugindir=/usr/$(get_libdir)/giFT \
		libgiftincdir=/usr/include/libgift \
		install || die "Install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	einfo "It is recommended that you re-run gift-setup as"
	einfo "the user you will run the giFT daemon as:"
	einfo "\tgift-setup"
	echo
	einfo "Alternatively you can add the following line to"
	einfo "your ~/.giFT/giftd.conf configuration file:"
	einfo "plugins = OpenFT:FastTrack"
}
