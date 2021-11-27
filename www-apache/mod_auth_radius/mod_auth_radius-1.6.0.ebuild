# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit apache-module depend.apache

DESCRIPTION="Radius authentication for Apache"
HOMEPAGE="https://freeradius.org/sub_projects/ https://github.com/FreeRADIUS/mod_auth_radius/"
SRC_URI="https://github.com/FreeRADIUS/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"

APACHE2_MOD_DEFINE="AUTH_RADIUS"

DOCFILES="README.asciidoc"

need_apache2

# Work around Bug #616612
pkg_setup() {
	_init_apache2
	_init_apache2_late
}

pkg_postinst() {
	if [[ -n "${REPLACING_VERSIONS}" ]]; then
		for v in ${REPLACING_VERSIONS}; do
			if ver_test ${v} -lt 1.6.0; then
				ewarn "Please note that upstream has changed the name of this module from"
				ewarn "    ${PN}-2.0.so"
				ewarn "to simply"
				ewarn "    ${PN}.so"
			fi
		done
	fi
}
