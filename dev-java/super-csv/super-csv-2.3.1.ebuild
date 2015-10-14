# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="source doc test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A fast, programmer-friendly, free CSV library for Java"
HOMEPAGE="http://super-csv.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.zip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/ant-junit:0
	)"

IUSE=""

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_BUILD_TARGET="package"
EANT_BUILD_XML="${PN}/build.xml"

java_prepare() {
	cp -v "${FILESDIR}/${P}-build.xml" "${S}/${PN}/build.xml" || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "${PN}/target/${P}.jar" "${PN}.jar"
	dodoc README.md
	use doc && java-pkg_dojavadoc "${PN}/target/site/apidocs"
	use source && java-pkg_dosrc "${PN}/src/main/java"
}
