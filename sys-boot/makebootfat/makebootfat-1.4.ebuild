# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="Command line utility able to create bootable USB disks"
HOMEPAGE="http://advancemame.sourceforge.net/boot-readme.html"
SRC_URI="mirror://sourceforge/advancemame/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-boot/syslinux"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die

	insinto /usr/share/makebootfat
	doins mbrfat.bin || die

	dodoc doc/*.txt
	dohtml doc/*.html
}
