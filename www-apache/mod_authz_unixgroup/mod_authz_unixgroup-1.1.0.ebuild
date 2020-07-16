# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit apache-module

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/phokz/mod-auth-external.git"
	inherit git-r3
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="https://github.com/phokz/mod-auth-external/archive/${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/mod-auth-external-${P}"
fi

DESCRIPTION="An Apache2 authorization DSO using unix groups"
HOMEPAGE="https://github.com/phokz/mod-auth-external"

LICENSE="Apache-1.1"
SLOT="0"
need_apache2_4

DOCFILES="CHANGES INSTALL README NOTICE"

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="AUTHZ_UNIXGROUP"

pkg_setup() {
	_init_apache2
	_init_apache2_late
}
