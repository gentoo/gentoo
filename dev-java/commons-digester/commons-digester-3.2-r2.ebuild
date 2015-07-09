# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-digester/commons-digester-3.2-r2.ebuild,v 1.2 2015/07/09 09:37:46 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

inherit eutils java-pkg-2 java-ant-2

MY_P="${PN}3-${PV}-src"

DESCRIPTION="Reads XML configuration files to provide initialization of various Java objects within the system"
HOMEPAGE="http://commons.apache.org/digester/"
SRC_URI="mirror://apache/commons/digester/source/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="3.2"
KEYWORDS="amd64 x86 ppc ppc64"

CDEPEND="dev-java/cglib:3
	dev-java/commons-beanutils:1.7
	>=dev-java/commons-logging-1.0.2:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}
	test? (
		dev-java/junit:4
		dev-java/ant-junit:0
	)"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="commons-beanutils-1.7,commons-logging,cglib-3"

java_prepare() {
	cp "${FILESDIR}"/${PN}-2.1-build.xml build.xml || die

	# Doesn't work.
	rm -v src/test/java/org/apache/commons/digester3/Digester153TestCase.java
}

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${PN}.jar

	dodoc RELEASE-NOTES.txt

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/org
	use examples && java-pkg_doexamples src/examples
}
