# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit linux-info systemd

DESCRIPTION="Modify realtime scheduling policy and priority of IRQ handlers"
HOMEPAGE="http://www.rncbc.org/archive/#rtirq"
SRC_URI="http://www.rncbc.org/archive/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	get_version

	# Correct config file path.
	sed -i -e "s:^\(RTIRQ_CONFIG\=\)\(.*\):\1/etc/conf.d/rtirq:" ${PN}.sh || die
	sed -i -e "s:/etc/sysconfig/rtirq:/etc/conf.d/rtirq:" ${PN}.conf || die

	default
}

src_install() {
	dosbin rtirq.sh
	doinitd "${FILESDIR}"/rtirq
	newconfd rtirq.conf rtirq
	systemd_dounit rtirq.service
}

pkg_postinst() {
	if [[ ${KV_LOCAL} != *rt* ]] ; then
		elog "To use rtirq you need a realtime kernel."
		elog "Realtime kernel sources are supplied in sys-kernel/rt-sources."
	fi
}
