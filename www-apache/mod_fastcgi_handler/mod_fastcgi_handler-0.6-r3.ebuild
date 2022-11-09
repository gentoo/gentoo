# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit apache-module

DESCRIPTION="A simple FastCGI handler module"
HOMEPAGE="https://github.com/hollow/mod_fastcgi_handler"
SRC_URI="https://github.com/hollow/mod_fastcgi_handler/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

APACHE2_MOD_CONF="20_${PN}"
APACHE2_MOD_DEFINE="FASTCGI_HANDLER"

APXS2_ARGS="-o ${PN}.so -c *.c"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6-implicit-function-decl.patch
)

need_apache2

pkg_setup() {
	# bug #653606
	# but true cause seems to be bug #616612
	_init_apache2
	_init_apache2_late
}
