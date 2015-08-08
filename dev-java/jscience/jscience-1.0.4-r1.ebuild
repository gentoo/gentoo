# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java Tools and Libraries for the Advancement of Sciences"
SRC_URI="http://jscience.org/${P}-src.zip"
HOMEPAGE="http://jscience.org/"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEP="~dev-java/javolution-2.2.4"

RDEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/jscience-${PV%.*}"

src_unpack() {
	unpack ${A}
	cd "${S}/lib"
	rm -v *.jar || die
	java-pkg_jar-from javolution-2.2.4
}

EANT_BUILD_TARGET="jarfile"

src_test() {
	# this works here as javolution is in lib/ and referenced in jar's manifest
	java -jar jscience.jar test || die "test failed"
}

src_install() {
	java-pkg_dojar jscience.jar

	dodoc doc/coding_standard.txt || die
	use doc && java-pkg_dojavadoc api
	use source && java-pkg_dosrc "${S}/src/org"
}
