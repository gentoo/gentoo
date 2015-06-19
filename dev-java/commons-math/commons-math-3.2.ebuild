# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-math/commons-math-3.2.ebuild,v 1.4 2014/03/03 23:37:22 pacho Exp $

EAPI="5"

# Tests are currently broken due to nasty -lib argument.
JAVA_PKG_IUSE="doc source" # test

inherit java-pkg-2 java-ant-2 java-osgi

MY_PN="${PN}3"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Lightweight, self-contained mathematics and statistics components"
HOMEPAGE="http://commons.apache.org/math/"
SRC_URI="mirror://apache/commons/math/source/${MY_P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 x86"

DEPEND=">=virtual/jdk-1.5"

# Tests are currently broken due to nasty -lib argument.
# test? (
# 	dev-java/ant-junit4
# 	dev-java/hamcrest-core:0
# )"

RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${MY_P}-src"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die

	sed -i 's/manifest=".*MANIFEST.MF"//g' build.xml || die
	sed -i '/name="Main-Class"/d' build.xml || die
}

# Tests are currently broken due to nasty -lib argument.
# src_test() {
# 	java-pkg_jar-from junit-4
# 	java-pkg_jar-from hamcrest-core
# 	ANT_TASKS="ant-junit4" eant -Djunit.jar=junit.jar test
# }

src_install() {
	java-osgi_newjar target/${MY_P}.jar ${MY_PN} ${MY_PN} "Export-Package: ${MY_PN}"

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/org
}
