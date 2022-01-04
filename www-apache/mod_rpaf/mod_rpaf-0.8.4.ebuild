# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit apache-module depend.apache

DESCRIPTION="Reverse proxy add forward module"
HOMEPAGE="https://github.com/gnif/mod_rpaf"
SRC_URI="https://github.com/gnif/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="RPAF"

need_apache2_4

# Work around Bug #616612
pkg_setup() {
	_init_apache2
	_init_apache2_late
}
