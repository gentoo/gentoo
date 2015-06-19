# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/microba/microba-0.4.4.ebuild,v 1.4 2007/11/25 14:40:00 ranger Exp $

JAVA_PKG_BSFIX="off"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Swing components for date operations and palettes"
HOMEPAGE="http://microba.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-full.zip"
LICENSE="BSD"
KEYWORDS="amd64 ppc x86"
SLOT="0"

COMMON_DEPEND=">=dev-java/jgraph-5.9.2"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEPEND}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

IUSE=""

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./${P}-sources.jar
	rm *.jar || die

	# do not delete stuff after it's zipped
	sed -i -e "s/<delete/<mkdir/" build.xml

	cd lib-compiletime
	rm *.jar || die
	java-pkg_jar-from jgraph jgraph.jar
}

EANT_BUILD_TARGET="bin_release"
EANT_DOC_TARGET="doc_release"

src_install() {
	java-pkg_newjar redist/${P}.jar
	dodoc *.txt || die
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/com
}
