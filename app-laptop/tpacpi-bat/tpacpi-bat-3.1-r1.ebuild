# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Control battery thresholds of recent ThinkPads, not supported by tp_smapi"
HOMEPAGE="https://github.com/teleshoes/tpacpi-bat"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/teleshoes/tpacpi-bat.git"
else
	SRC_URI="https://github.com/teleshoes/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	sys-power/acpi_call
	dev-lang/perl"

src_install() {
	dobin tpacpi-bat
	dodoc README.md battery_asl

	newinitd "${FILESDIR}"/${PN}.initd.2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd.1 ${PN}
	systemd_newunit examples/systemd_fixed_threshold/tpacpi.service \
		${PN}.service
}
