# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit mount-boot

MY_P="${P/nvram-/}"
DESCRIPTION="PowerOff Boot-Images for nvram-wakeup (not needed for GRUB)"
HOMEPAGE="http://sourceforge.net/projects/nvram-wakeup/"
SRC_URI="mirror://sourceforge/nvram-wakeup/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /boot/nvram-wakeup
	doins apm-poweroff.bin bzImage.2.4.20.poweroff dioden-poweroff \
		|| die "doins"
	dodoc *.patch *.diff *.txt config.*
}
