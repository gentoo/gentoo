# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Command line utility able to create bootable USB disks"
HOMEPAGE="http://advancemame.sourceforge.net/boot-readme.html"
SRC_URI="https://downloads.sourceforge.net/advancemame/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-boot/syslinux"
DEPEND="${RDEPEND}"

src_install() {
	default

	insinto /usr/share/makebootfat
	doins mbrfat.bin

	dodoc doc/*.txt
	docinto html
	dodoc doc/*.html
}
