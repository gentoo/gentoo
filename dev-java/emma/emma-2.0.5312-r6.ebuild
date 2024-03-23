# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_PROVIDES="
	emma:emma:${PV}
	emma:emma_ant:${PV}
"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Free Java code coverage tool"
HOMEPAGE="https://emma.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/emma/emma-release/${PV}/${P}-src.zip"
S="${WORKDIR}/${P}"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

IUSE="+launcher"

BDEPEND="app-arch/unzip"
CP_DEPEND=">=dev-java/ant-1.10.14:0"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*
	launcher? ( !sci-biology/emboss:0 )"

PATCHES=( "${FILESDIR}/emma-2.0.5312-java15api.patch" )

JAVADOC_CLASSPATH="ant"
JAVADOC_SRC_DIRS=(
	core/data core/java1{2,3,4}
	ant/ant1{4,5}
)

src_prepare() {
	default #780585
}

src_compile() {
	einfo "Compiling emma.jar"
	JAVA_JAR_FILENAME="emma.jar"
	JAVA_MAIN_CLASS="emmarun"
	JAVA_RESOURCE_DIRS=( core/res )
	JAVA_SRC_DIR=( core/data core/java1{2,3,4} )
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":emma.jar"
	rm -r target || die

	einfo "Compiling emma_ant.jar"
	JAVA_JAR_FILENAME="emma_ant.jar"
	JAVA_MAIN_CLASS="com.vladium.emma.ANTMain"
	JAVA_RESOURCE_DIRS=()
	JAVA_SRC_DIR=( ant/ant1{4,5} )
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":emma_ant.jar"
	rm -r target || die

	use doc && ejavadoc
}

src_install() {
	java-pkg_dojar "emma.jar" "emma_ant.jar"
	java-pkg_register-ant-task

	use launcher && java-pkg_dolauncher ${PN} --main emmarun

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc core/data/*
		java-pkg_dosrc core/java1{2,3,4}/*
		java-pkg_dosrc ant/ant1{4,5}*
	fi
}
