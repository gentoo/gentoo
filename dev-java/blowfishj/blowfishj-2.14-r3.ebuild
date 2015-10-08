# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Blowfish implementation in Java"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"
HOMEPAGE="http://blowfishj.sourceforge.net/index.html"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/ant-junit:0
	)"

RDEPEND=">=virtual/jre-1.6"

java_prepare() {
	cd "${S}" || die
	java-ant_ignore-system-classes
	mkdir -p target/lib || die
	cd target/lib || die
	use test && java-pkg_jar-from --build-only junit
}

src_test() {
	ANT_TASKS="ant-junit" eant test -DJunit.present=true
}

src_install() {
	java-pkg_newjar target/${P}.jar

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/net
}
