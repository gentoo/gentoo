# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_PN="beanshell"
MY_BETA="b6"
MY_PV="${PV%%_*}"
MY_P="${PN}-${MY_PV}${MY_BETA}"

DESCRIPTION="A small embeddable Java source interpreter"
HOMEPAGE="https://github.com/beanshell/beanshell"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${MY_PV}${MY_BETA}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND="
	dev-java/bsf:2.3
	java-virtuals/servlet-api:3.0
"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8"

DEPEND="
	${CDEPEND}
	test? ( dev-java/ant-junit:0 )
	source? ( app-arch/zip )
	virtual/jdk:1.8"

S="${WORKDIR}/${MY_PN}-${MY_PV}${MY_BETA}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_BUILD_TARGET="jarall"
EANT_DOC_TARGET="javadoc"
EANT_GENTOO_CLASSPATH="
	bsf-2.3
	servlet-api-3.0
"

java_prepare() {
	java-pkg_clean
}

EANT_TEST_TARGET="test"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "dist/${MY_P}.jar" "${PN}.jar"

	java-pkg_dolauncher "${PN}-console" --main bsh.Console
	java-pkg_dolauncher "${PN}-interpreter" --main bsh.Interpreter

	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/bsh
}
