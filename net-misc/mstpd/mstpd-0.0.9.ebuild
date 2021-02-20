# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1 systemd

DESCRIPTION="Multiple spanning tree protocol daemon"
HOMEPAGE="https://github.com/mstpd/mstpd"
SRC_URI="https://github.com/mstpd/mstpd/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-bashcompletiondir="$(get_bashcompdir)" \
		--with-systemdunitdir="$(systemd_get_systemunitdir)" \
		--localstatedir="${EPREFIX}"/var
}

src_install() {
	default
	dosym ../../sbin/bridge-stp /lib/mstpctl-utils/mstpctl_restart_config
	dosym bridge-stp /sbin/mstp_restart
}
