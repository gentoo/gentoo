# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Utility for spinning down hard disks after a period of idle time"
HOMEPAGE="http://hd-idle.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${PN}

DOCS=( debian/changelog README )

src_install() {
	default_src_install
	newinitd "${FILESDIR}"/hd-idle-init hd-idle
	newconfd "${FILESDIR}"/hd-idle-conf hd-idle
}

pkg_postinst() {
	if [[ ! -f /proc/diskstats ]]
	then
		ewarn "Please note that hd-idle uses /proc/diskstats to read disk"
		ewarn "statistics. If this file is not present, hd-idle won't work."
		ewarn "You should check your kernel configuration and make sure"
		ewarn "it includes CONFIG_PROC_FS=y."
	fi
}
