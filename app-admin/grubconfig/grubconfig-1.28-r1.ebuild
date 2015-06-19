# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/grubconfig/grubconfig-1.28-r1.ebuild,v 1.3 2012/01/15 15:31:16 phajdan.jr Exp $

inherit multilib

DESCRIPTION="Simple Tool to configure Grub-Bootloader"
HOMEPAGE="http://www.tux.org/pub/people/kent-robotti/looplinux/"
SRC_URI="http://www.tux.org/pub/people/kent-robotti/looplinux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

DEPEND=">=dev-util/dialog-0.7"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s:/usr/lib/grub:/$(get_libdir)/grub:g" \
		grubconfig || die
}

src_install() {
	dosbin grubconfig || die
	dodoc README
}
