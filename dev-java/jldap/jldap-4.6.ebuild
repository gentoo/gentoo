# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jldap/jldap-4.6.ebuild,v 1.2 2015/07/05 17:34:55 monsieurp Exp $
EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="LDAP Class Libraries for Java (JLDAP)"
HOMEPAGE="http://www.openldap.org/jldap/"
SRC_URI="http://dev.gentoo.org/~monsieurp/packages/${P}.tar.gz"

LICENSE="OPENLDAP"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc source"

CDEPEND="dev-java/openspml:0
	dev-java/openspml2:0
	dev-java/commons-httpclient:3
	dev-java/junit:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	app-arch/zip
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"

EANT_GENTOO_CLASSPATH="openspml,openspml2,commons-httpclient-3"

EANT_BUILD_TARGET="release"
EANT_BUILD_XML="build.xml"

EANT_DOC_TARGET="docdeveloper"

# [0]: complete rewrite of build.xml
# [1]: disable debugging at compile time
PATCHES=(
	"${FILESDIR}"/${P}-build.xml.patch
	"${FILESDIR}"/${P}-Debug.java.patch
)

java_prepare() {
	epatch ${PATCHES[@]}
}

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit"
EANT_TEST_TARGET="test"

src_test() {
	EANT_GENTOO_CLASSPATH_EXTRA="${S}/lib/${PN}.jar"
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar lib/${PN}.jar

	dodoc README README.dsml || die
	dohtml *.html || die

	if use doc; then
		dodoc design/* || die
		java-pkg_dojavadoc doc
	fi

	use source && java-pkg_dosrc org com
}
