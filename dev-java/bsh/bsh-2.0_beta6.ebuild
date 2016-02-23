# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_PN="beanshell"
MY_BETA="b6"
MY_PV="${PV%%_*}"
MY_P="${PN}-${MY_PV}${MY_BETA}"

DESCRIPTION="A small embeddable Java source interpreter"
HOMEPAGE="https://github.com/beanshell/beanshell"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${MY_PV}${MY_BETA}.zip -> ${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

CDEPEND="
	dev-java/bsf:2.3
	java-virtuals/servlet-api:3.0
"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	test? (
		dev-java/ant-junit:0
	)
	app-arch/unzip
	>=virtual/jdk-1.6"

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

	use doc && java-pkg_dohtml -r javadoc
	use source && java-pkg_dosrc src/bsh
}
