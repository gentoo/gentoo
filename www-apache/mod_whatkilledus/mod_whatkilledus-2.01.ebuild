# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit apache-module depend.apache

DESCRIPTION="Debug segmentation faults in Apache threads"
HOMEPAGE="http://emptyhammock.com/projects/httpd/diag/"
SRC_URI="http://emptyhammock.com/downloads/wku_bt-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=www-apache/mod_backtrace-2.01
	=www-servers/apache-2*[debug]"
DEPEND="${RDEPEND}
	app-arch/unzip"

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="BACKTRACE WHATKILLEDUS"

need_apache2

S="${WORKDIR}/wku_bt-${PV}"

src_compile() {
	APXS2_ARGS="-c ${PN}.c diag.c -ldl"
	apache-module_src_compile
}
