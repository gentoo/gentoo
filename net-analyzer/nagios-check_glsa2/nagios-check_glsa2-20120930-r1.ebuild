# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/nagios-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Nagios check script for GLSAs (Gentoo Linux Security Advisories)"
HOMEPAGE="https://github.com/craig/check_glsa2"
SRC_URI="https://dev.gentoo.org/~flameeyes/${MY_PN}/${MY_P}.tar.xz"

LICENSE="GPL-2 BSD-2"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	acct-group/nagios
	acct-user/nagios"
RDEPEND="
	${DEPEND}
	app-portage/gentoolkit"

S="${WORKDIR}/${MY_P}"
PATCHES=( "${FILESDIR}"/${PN}-20120930-CACHEDIR.patch )

src_install() {
	exeinto /usr/$(get_libdir)/nagios/plugins
	doexe *.sh

	dodoc README

	diropts -o nagios -g nagios
	keepdir /var/cache/${MY_PN}
}
