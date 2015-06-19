# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_jk/mod_jk-1.2.37.ebuild,v 1.5 2014/08/10 20:16:02 slyfox Exp $

EAPI="2"

inherit apache-module java-pkg-2

MY_P="tomcat-connectors-${PV}-src"

KEYWORDS="amd64 ppc x86"

DESCRIPTION="JK module for connecting Tomcat and Apache using the ajp13 protocol"
HOMEPAGE="http://tomcat.apache.org/connectors-doc/"
SRC_URI="mirror://apache/tomcat/tomcat-connectors/jk/${MY_P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

S="${WORKDIR}/${MY_P}/native"

APACHE2_MOD_FILE="${S}/apache-2.0/${PN}.so"
APACHE2_MOD_CONF="88_${PN}"
APACHE2_MOD_DEFINE="JK"

DOCFILES="CHANGES"
CONF_DIR="${WORKDIR}/${MY_P}/conf"

DEPEND=">=virtual/jdk-1.4"
RDEPEND=""

need_apache

pkg_setup() {
	java-pkg-2_pkg_setup
}

src_configure() {
	econf \
		--with-apxs=${APXS} \
		--with-apr-config=/usr/bin/apr-config \
		|| die "econf failed"
}

src_compile() {
	emake LIBTOOL="/bin/sh $(pwd)/libtool --silent" || die "emake failed"
}

src_install() {
	# install the workers.properties file
	insinto "${APACHE_CONFDIR}"
	newins "${CONF_DIR}/workers.properties.minimal" \
		jk-workers-minimal.properties || die
	newins "${CONF_DIR}/workers.properties" \
		jk-workers.properties || die
	doins "${CONF_DIR}/uriworkermap.properties" || die

	# call the nifty default src_install :-)
	apache-module_src_install
}

pkg_postinst() {
	elog "Tomcat is not a dependency of mod_jk any longer, if you intend"
	elog "to use it with Tomcat, you have to merge www-servers/tomcat on"
	elog "your own."

	elog "Advanced Directives and Options can be found at: "
	elog "http://tomcat.apache.org/connectors-doc/reference/workers.html"

	elog ""
	elog "JNI Worker Deprecation:"
	elog "Workers of type jni are broken since a long time."
	elog "Since there is no more use for them, they have been deprecated now,"
	elog "and will be removed in a future release."
}
