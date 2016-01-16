# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="source doc test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Commons Email aims to provide an API for sending email."
HOMEPAGE="http://commons.apache.org/email/"
SRC_URI="mirror://apache/commons/email/source/${P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

# Requires a slew of packages we don't ship yet.
RESTRICT="test"

CDEPEND="dev-java/oracle-javamail:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	test? (
		dev-java/ant-junit:0
	)
	>=virtual/jdk-1.6"

S="${WORKDIR}/${P}-src"

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_GENTOO_CLASSPATH="oracle-javamail"
EANT_BUILD_TARGET="package"

java_prepare() {
	cp "${FILESDIR}/${P}-build.xml" build.xml || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "target/${P}.jar" "${PN}.jar"
	dodoc {NOTICE,README,RELEASE-NOTES}.txt || die
	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java
}
