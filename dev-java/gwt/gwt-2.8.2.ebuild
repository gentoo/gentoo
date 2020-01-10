# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2 java-utils-2

GWT_TOOLS_COMMIT="f42d2729a3a8e6ba9b9aec069957bce5dc0f6f6d"
GWT_TOOLS_PN="tools"

GWT_COMMIT="faff18e7a1f065e3a4ac4ef32ab5cce394557070"

DESCRIPTION="Google Web Toolkit library"
HOMEPAGE="http://www.gwtproject.org/"
SRC_URI="https://github.com/gwtproject/${PN}/archive/${PV}.zip -> ${P}.zip
		https://github.com/gwtproject/${GWT_TOOLS_PN}/archive/${GWT_TOOLS_COMMIT}.zip -> ${PN}-${GWT_TOOLS_PN}-${GWT_TOOLS_COMMIT}.zip"
RESTRICT="mirror"
SLOT="2.8"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND="
		dev-java/json:0
		dev-java/guava:20
		dev-java/rhino:1.6
		>=dev-java/asm-5.0.3:4
		dev-java/eclipse-ecj:4.5
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
EANT_BUILD_TARGET="build"
EANT_EXTRA_ARGS="-Dgwt.gitrev=${GWT_COMMIT}"
EANT_GENTOO_CLASSPATH="
		json
		asm-4
		guava-20
		rhino-1.6
		eclipse-ecj-4.5
		validation-api-1.0
"

src_compile() {
	GWT_TOOLS="${WORKDIR}/${GWT_TOOLS_PN}-${GWT_TOOLS_COMMIT}" \
		GWT_VERSION="${PV}" \
		java-pkg-2_src_compile
}

src_test() {
	GWT_TOOLS="${WORKDIR}/${GWT_TOOLS_PN}-${GWT_TOOLS_COMMIT}" \
		GWT_VERSION="${PV}" \
		TZ=America/Los_Angeles ANT_OPTS=-Dfile.encoding=UTF-8 \
		ant ${EANT_EXTRA_ARGS} test || die
}

src_install() {
	java-pkg_dojar \
		build/lib/*.jar
	java-pkg_dolauncher i18nCreator --main com.google.gwt.i18n.tools.I18NCreator --jar gwt-dev.jar
	java-pkg_dolauncher webAppCreator --main com.google.gwt.user.tools.WebAppCreator --jar gwt-dev.jar
}
