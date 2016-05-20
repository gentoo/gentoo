# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit mount-boot

MY_P="sh-lilo-sel-${PV}"
DESCRIPTION="bootloader for the SuperH Lantank"
HOMEPAGE="http://oss.renesas.com/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2+ BSD"
SLOT="0"
KEYWORDS="-* sh"
IUSE=""
RESTRICT="strip"

S=${WORKDIR}/${MY_P}

QA_TEXTRELS_sh="sbin/lilo"

src_compile() { :; }

src_install() {
	into /
	dosbin precompiled/lilo || die
	insinto /boot
	doins precompiled/boot.b || die
	dosym . /boot/boot
	insinto /etc
	doins "${FILESDIR}"/lilo.conf || die
	dodoc ChangeLog README TODO
}
