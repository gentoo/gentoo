# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_PV=${PV//./_}
DESCRIPTION="An implementation of the primary security standards for XML"
HOMEPAGE="http://santuario.apache.org/"
SRC_URI="mirror://apache/santuario/java-library/${MY_PV}/${PN}-bin-${MY_PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

CDEPEND="
	dev-java/commons-logging:0
	dev-java/xalan:0
"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"
DEPEND="${CDEPEND}
	test? (
		dev-java/ant-junit:0
		dev-java/junit:4
	)
	>=virtual/jdk-1.6"

S="${WORKDIR}/${PN}-${MY_PV}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="commons-logging,xalan"
EANT_GENTOO_CLASSPATH_EXTRA="${S}"/build/xmlsec-${PV}.jar
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"
EANT_TEST_TARGET="build.test test"
WANT_ANT_TASKS="ant-junit"

# Buggy tests.
JAVA_RM_FILES=(
	src/test/java/org/apache/xml/security/test/encryption/BaltimoreEncTest.java
	src/test/java/org/apache/xml/security/test/encryption/XMLCipherTest.java
	src/test/java/org/apache/xml/security/test/utils/OldApiTest.java
)

java_prepare() {
	epatch "${FILESDIR}/${PV}-build.xml.patch"
	find "${S}" -name "*.jar" -delete || die
}

src_install() {
	java-pkg_newjar "${S}"/build/xmlsec-${PV}.jar ${PN}.jar

	use source && java-pkg_dosrc "${S}"/src/main/java/*
	use doc && java-pkg_dojavadoc "${S}"/build/docs/html/javadoc
}

src_test() {
	java-pkg-2_src_test
}
