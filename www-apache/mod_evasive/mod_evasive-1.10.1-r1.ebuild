# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit apache-module eutils

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Evasive maneuvers module for the event of an HTTP DoS"
HOMEPAGE="http://www.zdziarski.com/blog/?page_id=442"
SRC_URI="http://www.zdziarski.com/projects/mod_evasive/${P/-/_}.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="EVASIVE"

need_apache2_4

S="${WORKDIR}"/${PN}

src_prepare() {
	# Apache 2.4
	sed -i -e 's/connection->remote_ip/connection->client_ip/' mod_evasive20.c || die
	mv ${PN}20.c ${PN}.c
	sed -i -e 's:evasive20_module:evasive_module:g' ${PN}.c || die
}

src_install() {
	keepdir /var/log/apache2/evasive
	apache-module_src_install
}
