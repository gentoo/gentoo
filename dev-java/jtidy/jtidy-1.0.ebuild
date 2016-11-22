# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PV="r938"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Java port of HTML Tidy, an HTML syntax checker and pretty printer"
HOMEPAGE="http://jtidy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_PV}-sources.zip -> ${P}.zip"
LICENSE="HTML-Tidy W3C"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

CDEPEND="dev-java/ant-core:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

JAVA_ANT_ENCODING="UTF-8"
JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="ant-core"
EANT_BUILD_TARGET="jar"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/"${P}-build.xml.patch"
)

java_prepare() {
	epatch "${PATCHES[@]}"
}

src_install() {
	java-pkg_newjar "target/${MY_P}.jar"
	java-pkg_dolauncher "jtidy" --main org.w3c.tidy.Tidy

	use doc && java-pkg_dojavadoc target/javadoc/
	use source && java-pkg_dosrc src/main/java
}
