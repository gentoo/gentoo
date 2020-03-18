# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

MY_PN="google-gin"
MY_P="${MY_PN}-${PV}"

GIN_COMMIT="d62089f5b6ea33d842ab4646b51583c65a8be36b"

DESCRIPTION="Google Gin (GWT INjection)"
HOMEPAGE="https://gwtplus.github.io/google-gin/"
SRC_URI="https://github.com/gwtplus/google-gin/archive/${GIN_COMMIT}.zip -> ${MY_P}.zip"
RESTRICT="mirror"
SLOT="2.1"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND="
		dev-java/aopalliance:1
		dev-java/javax-inject:0
		dev-java/gwt:2.8
		dev-java/validation-api:1.0
"

RDEPEND="
		${CDEPEND}
		>=virtual/jre-1.8:*"
DEPEND="
		${CDEPEND}
		>=virtual/jdk-1.8:*"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_BUILD_XML="build.xml"
EANT_GENTOO_CLASSPATH="
		aopalliance-1
		javax-inject
		gwt-2.8
		validation-api-1.0
"

S="${WORKDIR}/${MY_PN}-${GIN_COMMIT}"

JAVA_RM_FILES=(
	trunk/lib/aopalliance.jar
	trunk/lib/javax.inject.jar
	lib/aopalliance.jar
	lib/javax.inject.jar
)

src_compile() {
	local EANT_BUILD_TARGET="compile"
	GWT_HOME="${EROOT}/usr/share/gwt-2.8/lib" \
		java-pkg-2_src_compile
	EANT_BUILD_TARGET="jars"
	GWT_HOME="${EROOT}/usr/share/gwt-2.8/lib" \
		java-pkg-2_src_compile
}

src_test() {
	GWT_HOME="${EROOT}/usr/share/gwt-2.8/lib" \
		ant test || die
}

src_install() {
	java-pkg_newjar \
		out/dist/${P}-src.jar ${PN}-src.jar
	java-pkg_newjar \
		out/dist/${P}.jar ${PN}.jar
	java-pkg_dojar \
		lib/*.jar
}
