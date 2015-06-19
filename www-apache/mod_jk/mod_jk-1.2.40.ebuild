# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_jk/mod_jk-1.2.40.ebuild,v 1.3 2015/05/27 11:16:46 ago Exp $

EAPI="5"
inherit apache-module java-pkg-opt-2 readme.gentoo

MY_P="tomcat-connectors-${PV#-*}-src"

KEYWORDS="amd64 ~ppc x86"

DESCRIPTION="JK module for connecting Tomcat and Apache using the ajp13 protocol."
HOMEPAGE="http://tomcat.apache.org/connectors-doc/"
SRC_URI="mirror://apache/tomcat/tomcat-connectors/jk/${MY_P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="java"

S="${WORKDIR}/${MY_P}/native"

APACHE2_MOD_FILE="${S}/apache-2.0/${PN}.so"
APACHE2_MOD_CONF="88_${PN}"
APACHE2_MOD_DEFINE="JK"

CONF_DIR="${WORKDIR}/${MY_P}/conf"

DEPEND="java? ( >=virtual/jdk-1.4 )"
RDEPEND=""

need_apache

DOC_CONTENTS="
	Advanced Directives and Options can be found at:
	http://tomcat.apache.org/connectors-doc/reference/workers.html
"

pkg_setup() {
	if use java ; then
		java-pkg-2_pkg_setup
	fi
}

src_configure() {
	econf \
		--with-apxs=${APXS} \
		--with-apr-config=/usr/bin/apr-config
}

src_compile() {
	emake LIBTOOL="/bin/sh $(pwd)/libtool --silent"
}

src_install() {
	# install the workers.properties file
	insinto "${APACHE_CONFDIR}"
	newins "${CONF_DIR}/workers.properties.minimal" \
		jk-workers-minimal.properties
	newins "${CONF_DIR}/workers.properties" \
		jk-workers.properties
	doins "${CONF_DIR}/uriworkermap.properties"

	# call the nifty default src_install
	apache-module_src_install

	readme.gentoo_create_doc
}
