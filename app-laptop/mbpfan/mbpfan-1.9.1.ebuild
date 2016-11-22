# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit linux-info systemd toolchain-funcs

DESCRIPTION="A simple daemon to control fan speed on all Macbook/Macbook Pros"
HOMEPAGE="https://github.com/dgraziotin/mbpfan"
SRC_URI="https://github.com/dgraziotin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # will fail if the hardware is unavailable, not useful

CONFIG_CHECK="~SENSORS_APPLESMC ~SENSORS_CORETEMP"

src_prepare() {
	sed -i -e "s:g++:$(tc-getCXX):g" Makefile || die
	default
}

src_install() {
	dosbin bin/mbpfan

	insinto /etc
	doins ${PN}.conf

	newinitd ${PN}.init.gentoo ${PN}
	systemd_dounit ${PN}.service

	einstalldocs
}
