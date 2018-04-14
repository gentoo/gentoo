# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc test source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Lightweight, self-contained mathematics and statistics components"
HOMEPAGE="https://commons.apache.org/math/"
SRC_URI="mirror://apache/commons/math/source/${P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 x86"

DEPEND="
	>=virtual/jdk-1.6
	test? (
		dev-java/ant-junit4
		dev-java/hamcrest-core:0
	)"

RDEPEND="
	>=virtual/jre-1.6"

S="${WORKDIR}/${P}-src"

PATCHES=( "${FILESDIR}"/${PF}-buildfixes.patch )

src_test() {
	java-pkg_jar-from junit-4
	java-pkg_jar-from hamcrest-core
	ANT_TASKS="ant-junit4" eant -Djunit.jar=junit.jar test
}

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	use doc && java-pkg_dojavadoc target/apidocs
	use source && java-pkg_dosrc src/main/java/org
}
