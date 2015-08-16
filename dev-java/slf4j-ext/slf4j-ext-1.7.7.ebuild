# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Simple Logging Facade for Java"
HOMEPAGE="http://www.slf4j.org/"
SRC_URI="http://www.slf4j.org/dist/${P/-ext/}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEP="dev-java/slf4j-api:0
	dev-java/javassist:3
	dev-java/cal10n:0
	dev-java/commons-lang:2.1"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/${P/-ext/}/${PN}"

RESTRICT="test" # causes loop with log4j:2

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="slf4j-api,javassist-3,cal10n,commons-lang-2.1"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"
EANT_TEST_ANT_TASKS="ant-junit"

java_prepare() {
	cp -v "${FILESDIR}"/${PV}-build.xml build.xml || die
	find "${S}" -name "*.jar" -delete || die
}

src_install() {
	java-pkg_dojar "${S}"/target/${PN}.jar
	use doc && java-pkg_dojavadoc "${S}"/target/site/apidocs
	use source && java-pkg_dosrc "${S}"/src/main/java/org
}
