# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit git-2

DESCRIPTION="Icinga Web 2 - Frontend for icinga2"
HOMEPAGE="http://www.icinga.org/"
EGIT_REPO_URI="https://github.com/Icinga/icingaweb2-module-pnp4nagios.git"
EGIT_BRANCH="master"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS=""

DEPEND=">=net-analyzer/icinga2-2.1.1
	>=www-apps/icingaweb2-2.0.0"
RDEPEND="${DEPEND}"

src_install() {
	mkdir -p "${D}/usr/share/icingaweb2/modules/${PN}"
	cp -R "${S}"/* "${D}/usr/share/icingaweb2/modules/${PN}"
}
