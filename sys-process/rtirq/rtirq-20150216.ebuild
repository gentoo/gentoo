# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

DESCRIPTION="Modify realtime scheduling policy and priority of IRQ handlers"
HOMEPAGE="http://www.rncbc.org/jack/"

SRC_URI="http://www.rncbc.org/jack/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sys-apps/util-linux-2.13"

src_prepare() {
	# Correct config file path.
	sed -i -e "s:^\(RTIRQ_CONFIG\=\)\(.*\):\1/etc/conf.d/rtirq:" ${PN}.sh || die
	sed -i -e "s:/etc/sysconfig/rtirq:/etc/conf.d/rtirq:" ${PN}.conf || die

	default
}

src_install(){
	dosbin ${PN}.sh
	doinitd "${FILESDIR}"/${PN}
	newconfd ${PN}.conf ${PN}
}

pkg_postinst(){
	if [[ "$(rc-config list default | grep rtirq)" = "" ]] ; then
		elog "You probably want to add rtirq to the default runlevel, i.e."
		elog "  rc-update add rtirq default"
	fi
	if [[ "$(uname -r | grep rt)" = "" ]] ; then
		elog "To use rtirq you need a realtime kernel."
		elog "Realtime kernel sources are supplied in sys-kernel/rt-sources."
	fi
	elog "To display the rtirq status issue:"
	elog "  /etc/init.d/rtirq status"
}
