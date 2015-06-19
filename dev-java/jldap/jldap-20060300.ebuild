# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jldap/jldap-20060300.ebuild,v 1.7 2007/08/16 00:08:02 dertobi123 Exp $

inherit java-pkg-2 java-ant-2

DESCRIPTION="LDAP Class Libraries for Java (JLDAP)"
HOMEPAGE="http://www.openldap.org/jldap/"
SRC_URI="mirror://gentoo/jldap-Mar_ndk_2006-gentoo.tar.bz2"

LICENSE="OPENLDAP"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.4
		=dev-java/commons-httpclient-2.0*
		dev-java/openspml
		dev-java/openspml2"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

S="${WORKDIR}/openldap-${PN}"

src_unpack() {

	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/200603-javac.xml.patch"

	java-ant_bsfix_one "${S}/javac.xml"

	mkdir "${S}/ext"
	cd "${S}/ext"
	java-pkg_jar-from commons-httpclient
	java-pkg_jar-from openspml
	java-pkg_jar-from openspml2
}

EANT_BUILD_TARGET="release"
EANT_DOC_TARGET="doc"

src_install() {
	java-pkg_dojar lib/ldap.jar

	dodoc README README.dsml || die
	dohtml *.html || die

	if use doc; then
		dodoc design/* || die
		java-pkg_dojavadoc doc
	fi

	use source && java-pkg_dosrc org com
}
