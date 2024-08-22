# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An Apache2 authentication DSO using external programs"
HOMEPAGE="https://github.com/phokz/mod-auth-external"

inherit apache-module

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/phokz/mod-auth-external.git"
	inherit git-r3
	S="${WORKDIR}/${P}/mod_authnz_external"
else
	SRC_URI="https://github.com/phokz/mod-auth-external/archive/${P}.tar.gz"
	S="${WORKDIR}/mod-auth-external-${P}"
	KEYWORDS="amd64 x86"
fi

LICENSE="Apache-1.1"
SLOT="2"

need_apache2_4

DOCFILES="AUTHENTICATORS CHANGES INSTALL INSTALL.HARDCODE README TODO UPGRADE"

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="AUTHNZ_EXTERNAL"

pkg_setup() {
	_init_apache2
	_init_apache2_late
}
