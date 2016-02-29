# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Icinga Web 2 plugin for pnp4nagios"
HOMEPAGE="http://www.icinga.org/"
MY_PN="icingaweb2-module-pnp"
SRC_URI="https://codeload.github.com/Icinga/${MY_PN}/tar.gz/v${PV} -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS=""

DEPEND=">=net-analyzer/icinga2-2.1.1
	>=www-apps/icingaweb2-2.0.0"
RDEPEND="${DEPEND}"

src_install() {
	mkdir -p "${D}/usr/share/icingaweb2/modules/pnp"
	cp -R "${S}"/* "${D}/usr/share/icingaweb2/modules/pnp"
}
