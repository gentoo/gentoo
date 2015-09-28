# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2 versionator

MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="JiBX: Binding XML to Java Code - Generators"
HOMEPAGE="http://jibx.sourceforge.net/"
SRC_URI="mirror://sourceforge/jibx/jibx_${MY_PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

CDEPEND="dev-java/bcel:0
	dev-java/jibx:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

S="${WORKDIR}/jibx"

java_prepare() {
	# http://jira.codehaus.org/browse/JIBX-207
	epatch "${FILESDIR}/1.1.5-build.patch"

	java-ant_rewrite-classpath "${S}/build/build.xml"

	rm -v "${S}"/lib/*.jar || die
}

EANT_FILTER_COMPILER="ecj-3.3"
EANT_BUILD_XML="build/build.xml"
EANT_BUILD_TARGET="jar-tools"
EANT_GENTOO_CLASSPATH="bcel,jibx"

src_install() {
	java-pkg_register-dependency jibx

	java-pkg_dojar "${S}/lib"/jibx-*.jar
	use source && java-pkg_dosrc "${S}"/build/src/* "${S}"/build/extras/*
}
