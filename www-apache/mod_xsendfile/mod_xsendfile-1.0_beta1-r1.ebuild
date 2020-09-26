# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit apache-module

MY_PV="1.0b1"
DESCRIPTION="Apache module that processes X-SENDFILE headers registered by the output handler"
HOMEPAGE="https://tn123.org/mod_xsendfile/"
SRC_URI="https://tn123.org/mod_xsendfile/beta/${PN}-${MY_PV}.tar.gz"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 sparc x86 ~amd64-linux"

need_apache2

src_install() {
	APACHE2_MOD_CONF="50_${PN}"
	APACHE2_MOD_DEFINE="XSENDFILE"
	# Triggers unfortunate QA warning in the eclass
	# See bug #515414, seems to be an apache-module.eclasss issue
	DOCFILES="docs/Readme.html"

	APACHE_MODULESDIR="/usr/$(get_libdir)/apache2/modules"

	apache-module_src_install
}
