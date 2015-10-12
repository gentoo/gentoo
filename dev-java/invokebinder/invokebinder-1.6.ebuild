# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Provide a friendly DSL for binding method handles"
HOMEPAGE="https://github.com/headius/invokebinder"
SRC_URI="https://github.com/headius/${PN}/archive/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"

S="${WORKDIR}/${PN}-${P}"

DEPEND=">=virtual/jdk-1.7
	test? (
		dev-java/ant-junit:0
	)"
RDEPEND=">=virtual/jre-1.7"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_TEST_TARGET="test"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "target/${P}.jar" "${PN}.jar"
	use source && java-pkg_dosrc src/main/java/com
	if use doc; then
		java-pkg_dojavadoc target/site/apidocs
		dodoc README.markdown
	fi
}
