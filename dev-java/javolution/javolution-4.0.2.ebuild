# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Java Solution for Real-Time and Embedded Systems"
SRC_URI="http://javolution.org/${P}-src.zip"
HOMEPAGE="http://javolution.org"
LICENSE="BSD"
SLOT="4"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/javolution-${PV%.*}"

EANT_BUILD_TARGET="clean _init_1.5 _compile jar"
EANT_DOC_TARGET="doc"

src_test() {
	java -jar "${PN}.jar" test || die "test failed"
}

src_install() {
	java-pkg_dojar "${PN}.jar"

	dodoc doc/coding_standard.txt
	dohtml index.html

	use doc && java-pkg_dojavadoc api
	use source && java-pkg_dosrc "${S}/src/${PN}"
}
