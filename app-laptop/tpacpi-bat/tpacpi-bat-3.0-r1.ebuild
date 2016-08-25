# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit systemd

if [ "${PV}" = "9999" ]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/teleshoes/tpacpi-bat.git https://github.com/teleshoes/tpacpi-bat.git"
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
	newinitd "${FILESDIR}"/${PN}.initd.2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd.1 ${PN}
	systemd_newunit tpacpi.service ${PN}.service
}
