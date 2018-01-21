# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info

DESCRIPTION="Utility for spinning down hard disks after a period of idle time"
HOMEPAGE="http://hd-idle.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}"

CONFIG_CHECK="~PROC_FS"

DOCS=( debian/changelog README )

src_install() {
	default_src_install
	newinitd "${FILESDIR}"/hd-idle-init hd-idle
	newconfd "${FILESDIR}"/hd-idle-conf hd-idle
}
