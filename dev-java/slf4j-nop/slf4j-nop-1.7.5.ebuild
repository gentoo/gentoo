# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Simple Logging Facade for Java"
HOMEPAGE="http://www.slf4j.org/"
SRC_URI="http://www.slf4j.org/dist/${P/-nop/}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

COMMON_DEP="dev-java/slf4j-api:0"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}
	test? ( dev-java/junit:4 )"

S="${WORKDIR}/${P/-nop/}/${PN}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="slf4j-api"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"
EANT_TEST_ANT_TASKS="ant-junit"

java_prepare() {
	cp -v "${FILESDIR}"/${PV}-build.xml "${S}"/build.xml || die
	find "${S}" -name "*.jar" -delete || die
}

src_install() {
	java-pkg_dojar "${S}"/target/${PN}.jar

	use doc && java-pkg_dojavadoc "${S}"/target/site/apidocs
	use source && java-pkg_dosrc "${S}"/src/main/java/org
}

src_test() {
	java-pkg-2_src_test
}
