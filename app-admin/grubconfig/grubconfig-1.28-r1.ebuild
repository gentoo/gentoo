# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit multilib

DESCRIPTION="Simple Tool to configure Grub-Bootloader"
HOMEPAGE="https://web.archive.org/web/20100410042718/http://www.tux.org/pub/people/kent-robotti/looplinux"
SRC_URI="http://gentoo/${P}.tar.gz"

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
