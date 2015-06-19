# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/sgopherd/sgopherd-13.01.ebuild,v 1.1 2013/03/18 14:16:24 pinkbyte Exp $

EAPI=5

inherit eutils

DESCRIPTION="Small Gopher Server written in GNU Bash"
HOMEPAGE="https://github.com/vain/sgopherd"
SRC_URI="https://github.com/vain/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="PIZZA-WARE"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="app-shells/bash
	sys-apps/sed
	sys-apps/xinetd"

src_prepare() {
	# Set default user to run sgopherd
	sed -i -e '/user/s/http/nobody/' xinetd/xinetd-example.conf || die 'sed failed'

	epatch_user
}

src_install() {
	dodoc README
	doman man8/"${PN}".8
	dobin "${PN}"
	insinto /etc/xinetd.d
	newins xinetd/xinetd-example.conf "${PN}"
	# TODO: add installation of systemd-related files
}

pkg_postinst() {
	elog "${PN} can be launched through xinetd"
	elog "Configuration options are in /etc/xinetd.d/${PN}"
}
