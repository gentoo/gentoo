# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Bash script that uses udisks to mount removable devices without GUI"
HOMEPAGE="https://sourceforge.net/projects/bashmount/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# sys-apps/util-linux -> lsblk
RDEPEND="app-shells/bash
	sys-apps/dbus
	sys-apps/util-linux
	sys-fs/udisks:2
	virtual/eject"
DEPEND=""

src_install() {
	dobin ${PN}
	insinto /etc
	doins ${PN}.conf
	doman ${PN}.1
	dodoc NEWS
}
