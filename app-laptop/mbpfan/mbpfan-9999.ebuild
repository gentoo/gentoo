# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 linux-info systemd toolchain-funcs

DESCRIPTION="A simple daemon to control fan speed on all Macbook/Macbook Pros"
HOMEPAGE="https://github.com/dgraziotin/mbpfan"
EGIT_REPO_URI="git://github.com/dgraziotin/${PN}.git"
LICENSE="GPL-3+"
SLOT="0"
RESTRICT="test" # will fail if the hardware is unavailable, not useful

CONFIG_CHECK="~SENSORS_APPLESMC ~SENSORS_CORETEMP"

src_prepare() {
	sed -i -e "s:g++:$(tc-getCXX):g" Makefile || die
	default
}

src_install() {
	emake DESTDIR="${D%/}" install

	rm -r "${D}"usr/share/doc/${PN} || die
	rm -r "${D}"lib/systemd/system || die

	newinitd ${PN}.init.gentoo ${PN}
	systemd_dounit ${PN}.service

	einstalldocs
}
