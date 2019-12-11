# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
JAVA_PKG_IUSE="doc examples source test"

inherit eutils java-pkg-2 java-ant-2

MY_P="${P}-src"
DESCRIPTION="Reads XML configuration files to provide initialization of various Java objects"
HOMEPAGE="http://commons.apache.org/digester/"
SRC_URI="mirror://apache/commons/digester/source/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

CDEPEND="dev-java/commons-beanutils:1.7
	>=dev-java/commons-collections-2.1:0
	>=dev-java/commons-logging-1.0.2:0"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/junit:0
		dev-java/ant-junit:0
	)
	${CDEPEND}"

S="${WORKDIR}/${P}-src"

# don't rewrite build.xml in examples
JAVA_PKG_BSFIX_ALL="no"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="commons-beanutils-1.7,commons-collections,commons-logging"

java_prepare() {
	epatch "${FILESDIR}/${PV}-build.xml-jar-target.patch"
}

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar "dist/${PN}.jar"

	dodoc RELEASE-NOTES.txt

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/org
	use examples && java-pkg_doexamples src/examples
}
