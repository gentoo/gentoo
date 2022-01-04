# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit apache-module depend.apache

DESCRIPTION="Log rotation support for mod_log_config based on strftime(3)"
HOMEPAGE="https://github.com/JBlond/mod_log_rotate"
SRC_URI="https://github.com/JBlond/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="LOG_ROTATE"
DOCFILES="README.md"

need_apache2

# Work around Bug #616612
pkg_setup() {
	_init_apache2
	_init_apache2_late
}
