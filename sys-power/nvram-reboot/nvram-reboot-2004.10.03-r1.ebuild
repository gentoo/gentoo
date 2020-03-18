# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mount-boot

MY_P="${P/nvram-/}"
DESCRIPTION="PowerOff Boot-Images for nvram-wakeup (not needed for GRUB)"
HOMEPAGE="https://sourceforge.net/projects/nvram-wakeup/"
SRC_URI="mirror://sourceforge/nvram-wakeup/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /boot/nvram-wakeup
	doins apm-poweroff.bin bzImage.2.4.20.poweroff dioden-poweroff
	dodoc *.patch *.diff *.txt config.*
}
