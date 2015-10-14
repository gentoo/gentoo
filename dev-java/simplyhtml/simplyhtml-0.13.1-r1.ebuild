# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"
inherit versionator java-pkg-2 java-ant-2

MY_PN="SimplyHTML"
MY_PV="$(replace_all_version_separators _)"

DESCRIPTION="Text processing application based on HTML and CSS files"
HOMEPAGE="http://simplyhtml.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}_src_${MY_PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE=""

CDEPEND="dev-java/javahelp:0
	dev-java/gnu-regexp:1"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

JAVA_PKG_FILTER_COMPILER="jikes"
JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_GENTOO_CLASSPATH="
	javahelp
	gnu-regexp-1
"
EANT_BUILD_TARGET="jar"
EANT_BUILD_XML="src/build.xml"

java_prepare() {
	# Avoid copying lib jars.
	sed -i '/copy file/d' src/build.xml || die
}

src_install() {
	local my_jars=(
		"${MY_PN}.jar"
		"${MY_PN}Help.jar"
	)

	for my_jar in "${my_jars[@]}"; do
		java-pkg_dojar "dist/lib/${my_jar}"
	done

	dodoc readme.txt
	use doc && java-pkg_dojavadoc dist/api
	use source && java-pkg_dosrc src/com src/de
}
