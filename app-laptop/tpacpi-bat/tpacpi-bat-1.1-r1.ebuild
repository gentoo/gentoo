# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/tpacpi-bat/tpacpi-bat-1.1-r1.ebuild,v 1.1 2013/12/06 14:49:15 ottxor Exp $

EAPI=5

inherit eutils systemd

if [ "${PV}" = "9999" ]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/teleshoes/tpacpi-bat.git http://github.com/teleshoes/tpacpi-bat.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/teleshoes/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
DESCRIPTION="Control battery thresholds of recent ThinkPads, which are not supported by tp_smapi"
HOMEPAGE="https://github.com/teleshoes/tpacpi-bat"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="sys-power/acpi_call
	dev-lang/perl"

src_install() {
	dodoc README battery_asl
	dobin tpacpi-bat
	newinitd "${FILESDIR}"/${PN}.initd.1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd.0 ${PN}
	systemd_newunit tpacpi.service ${PN}.service
}
