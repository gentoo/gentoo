# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit multilib user

DESCRIPTION="Nagios check script for GLSAs (Gentoo Linux Security Advisories)"
HOMEPAGE="https://github.com/craig/check_glsa2"

MY_PN="${PN/nagios-/}"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

SRC_URI="http://dev.gentoo.org/~flameeyes/${MY_PN}/${MY_P}.tar.xz"
LICENSE="GPL-2 BSD-2"
SLOT="0"

KEYWORDS="amd64"

RDEPEND="app-portage/gentoolkit"
DEPEND=""

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /dev/null nagios
}

src_prepare() {
	sed -i -e '/CACHEDIR=/s:=.*:=/var/cache/check_glsa2:' ${MY_PN}_cached.sh || die
}

src_install() {
	local nagiosplugindir=/usr/$(get_libdir)/nagios/plugins
	exeinto ${nagiosplugindir}
	doexe *.sh

	dodoc README

	diropts -o nagios -g nagios
	keepdir /var/cache/${MY_PN}
}
