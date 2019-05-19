# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Kvm and qemu init scripts"
HOMEPAGE="https://gitweb.gentoo.org/proj/kvm-tools.git/"

SRC_URI="https://dev.gentoo.org/~dolsen/releases/${PN}/${P}.tar.xz"
LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-emulation/qemu
	net-misc/socat"

S="${PORTAGE_BUILDDIR}/work/${PN}"

src_prepare() {
	epatch_user
}

src_install() {
	newinitd "${S}/"qemu-init-script qemu
	newconfd "${S}/"qemu-conf.example qemu.conf.example
	newsbin "${S}/"qtap-manipulate qtap-manipulate
	dosym qemu /etc/init.d/kvm
}

pkg_postinst() {
	elog "For bridging networking systems, you need these run time utilities:"
	elog "    net-misc/bridge-utils"
	elog "    sys-apps/usermode-utilities"
	elog ""
	elog "We will be updating these scripts to use"
	elog "iptables exclusively in the future"
}
