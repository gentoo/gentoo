# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/rhino/rhino-1.7.7.ebuild,v 1.1 2015/08/06 10:01:23 monsieurp Exp $

EAPI="5"
JAVA_PKG_IUSE="doc examples source test"
inherit java-pkg-2 java-ant-2 versionator

# rhino -> Rhino
MY_PN="${PN^}"

# 1.7.7 -> 1_7_7
MY_PV="$(replace_all_version_separators _ ${PV})"

# rhino1.7.7
MY_P="${PN}${PV}"

# Rhino1_7_7_RELEASE
MY_RELEASE="${MY_PN}${MY_PV}_RELEASE"

DESCRIPTION="An open-source implementation of JavaScript written in Java"
SRC_URI="https://github.com/mozilla/${PN}/archive/${MY_RELEASE}.zip"
HOMEPAGE="http://www.mozilla.org/rhino/"

LICENSE="MPL-1.1 GPL-2"
SLOT="1.7"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

# ../rhino-Rhino1_7_7_RELEASE
S="${WORKDIR}/${PN}-${MY_RELEASE}"

CDEPEND=""
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/emma:0
		dev-java/junit:4
		dev-java/ant-junit:0
		dev-java/hamcrest-core:1.3
	)
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_BUILD_XML="${S}/build.xml"
EANT_BUILD_TARGET="jar"

PATCHES=(
	"${FILESDIR}"/${P}-testsrc-build.xml.patch
)

EANT_TEST_TARGET="junit"

# StackOverFlow errors arise on some tests.
# Further, the test suite takes way too much time (> 5 min).
# Maybe reduce the numbers of tests?
RESTRICT="test"

java_prepare() {
	find . \
		-type f \
		-name \*.jar \
		-print \
		-exec rm -v {} \; || die "Couldn't delete bundled jar files."

	epatch ${PATCHES[@]}

	if use test; then
		mkdir lib || die
		java-pkg_jar-from --build-only emma emma.jar lib/emma.jar
		java-pkg_jar-from --build-only emma emma_ant.jar lib/emma_ant.jar
		java-pkg_jar-from --build-only hamcrest-core-1.3 hamcrest-core.jar lib/hamcrest.jar
		java-pkg_jar-from --build-only junit-4 junit.jar lib/junit.jar
	fi
}

src_compile() {
	java-pkg-2_src_compile

	if use source; then
		EANT_BUILD_TARGET="source-zip" \
			java-pkg-2_src_compile
	fi
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar build/${MY_P}/js.jar

	java-pkg_dolauncher jsscript-${SLOT} \
		--main org.mozilla.javascript.tools.shell.Main

	use doc && java-pkg_dojavadoc "build/${MY_P}/javadoc"
	use examples && java-pkg_doexamples examples
	use source && java-pkg_dosrc {src,toolsrc,xmlimplsrc}/org
}
