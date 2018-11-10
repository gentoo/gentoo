# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit apache-module

DESCRIPTION="A simple FastCGI handler module"
HOMEPAGE="https://github.com/hollow/mod_fastcgi_handler"
SRC_URI="https://github.com/hollow/mod_fastcgi_handler/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

APACHE2_MOD_CONF="20_${PN}"
APACHE2_MOD_DEFINE="FASTCGI_HANDLER"

APXS2_ARGS="-o ${PN}.so -c *.c"

need_apache2
