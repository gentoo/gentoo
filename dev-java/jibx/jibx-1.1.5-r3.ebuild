# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 versionator

MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="JiBX: Binding XML to Java Code"
HOMEPAGE="http://jibx.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${MY_PV}.zip -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

CDEPEND="
	dev-java/bcel:0
	dev-java/xpp3:0
	dev-java/dom4j:1
	dev-java/ant-core:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}/${PN}"

DOCS=( changes.txt docs/binding.dtd docs/binding.xsd )
HTML_DOCS=( readme.html docs starter tutorial )

EANT_BUILD_TARGET="small-jars"
EANT_BUILD_XML="build/build.xml"

src_prepare() {
	default
	java-pkg_clean
	java-pkg_jar-from --into lib ant-core,bcel,dom4j-1,xpp3
}

src_install() {
	java-pkg_dojar "${S}"/lib/${PN}*.jar
	use source && java-pkg_dosrc build/src/* build/extras/*
	einstalldocs
}
