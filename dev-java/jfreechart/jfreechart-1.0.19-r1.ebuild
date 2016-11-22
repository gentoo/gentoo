# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JFreeChart is a free Java class library for generating charts"
HOMEPAGE="http://www.jfree.org/jfreechart"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

CDEPEND="
	dev-java/jfreesvg:2.1
	>=dev-java/jcommon-1.0.23:1.0
	java-virtuals/servlet-api:3.0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	test? (
		dev-java/ant-junit:0
		dev-java/junit:4
	)
	app-arch/unzip
	>=virtual/jdk-1.6"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.19-build.xml.patch"
	"${FILESDIR}/${PN}-1.0.19-fix-TimeSeriesCollectionTest.patch"
)

JAVA_ANT_ENCODING="ISO-8859-1"
JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_BUILD_XML="ant/build.xml"
EANT_BUILD_TARGET="compile-experimental"
EANT_GENTOO_CLASSPATH="
	jfreesvg-2.1
	jcommon-1.0
	servlet-api-3.0
"

EANT_DOC_TARGET="javadoc"

src_prepare() {
	epatch "${PATCHES[@]}"

	java-pkg_clean
}

src_install() {
	java-pkg_newjar "lib/${P}.jar" "${PN}.jar"
	java-pkg_newjar "lib/${P}-experimental.jar" "${PN}-experimental.jar"

	dodoc README.txt ChangeLog NEWS

	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc source/org
}
