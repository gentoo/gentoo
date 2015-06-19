# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/slf4j-api/slf4j-api-1.7.5-r1.ebuild,v 1.1 2014/03/11 04:15:19 radhermit Exp $

EAPI=5
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Simple Logging Facade for Java"
HOMEPAGE="http://www.slf4j.org/"
SRC_URI="http://www.slf4j.org/dist/${P/-api/}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	test? (
		dev-java/junit:4
		dev-java/ant-junit4:0
	)"

S="${WORKDIR}/${P/-api/}/${PN}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_TEST_GENTOO_CLASSPATH="junit-4"
EANT_TEST_ANT_TASKS="ant-junit"

java_prepare() {
	cp -v "${FILESDIR}"/${PV}-build.xml build.xml || die
	find "${WORKDIR}" -iname '*.jar' -delete || die
}

src_install() {
	java-pkg_dojar target/${PN}.jar

	use doc && java-pkg_dojavadoc "${S}"/apidocs
	use source && java-pkg_dosrc src/main/java/org
}

src_test() {
	java-pkg-2_src_test
}
