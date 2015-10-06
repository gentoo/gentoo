# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A small set of classes designed to make working with JDBC easier"
HOMEPAGE="http://commons.apache.org/dbutils/"
SRC_URI="mirror://apache/commons/dbutils/source/${P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/mockito:0
		dev-java/ant-junit:0
		dev-java/hamcrest-core:1.3
	)"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${P}-src"

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_TEST_TARGET="test"
EANT_TEST_GENTOO_CLASSPATH="
	mockito
	hamcrest-core-1.3
"

# Uses a bunch of deprecated methods.
JAVA_RM_FILES=(
	src/test/java/org/apache/commons/dbutils/handlers/ArrayHandlerTest.java
)

java_prepare() {
	cp "${FILESDIR}"/"${P}-build.xml" build.xml || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar
	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java
}
