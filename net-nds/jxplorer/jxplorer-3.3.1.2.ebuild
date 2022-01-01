# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test"
inherit desktop java-pkg-2 java-ant-2 prefix virtualx

DESCRIPTION="Fully functional LDAP browser written in Java"
HOMEPAGE="http://jxplorer.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-project.zip"
S="${WORKDIR}/${PN}"

LICENSE="CAOSL"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

COMMON_DEPEND="
	>=dev-java/javahelp-2.0.02_p46:0
"
RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-1.5
"
DEPEND="${COMMON_DEPEND}
	virtual/jdk:1.8
	test? ( dev-java/junit:0 )
"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="javahelp"
EANT_TEST_ANT_TASKS="ant-junit"

PATCHES=( "${FILESDIR}"/3.3-disable-jxworkbench.patch )

src_prepare() {
	default

	rm -v jars/*.jar || die
	sed -i -e 's/<fileset dir="${jasper}.*//g' build.xml || die

	if use test; then
		EANT_GENTOO_CLASSPATH_EXTRA=$(java-pkg_getjars --build-only junit)
	else
		find . -iname '*Test*.java' -delete || die
	fi
}

src_test() {
	VIRTUALX_COMMAND="java-pkg-2_src_test" virtx emake -j1
}

src_install() {
	java-pkg_dojar jars/${PN}.jar

	insinto /usr/share/${PN}
	doins -r icons images htmldocs language templates plugins security.default csvconfig.txt.default

	dodoc README*.TXT

	# By default the config dir is ${HOME}/jxplorer
	java-pkg_dolauncher ${PN} \
		--main com.ca.directory.jxplorer.JXplorer \
		--pwd '"${HOME}/.jxplorer"' \
		-pre "${FILESDIR}/${PN}-3-pre"

	eprefixify "${ED}/usr/bin/${PN}"

	use source && java-pkg_dosrc src/com
	use doc && java-pkg_dojavadoc docs/api

	make_desktop_entry ${PN} JXplorer /usr/share/jxplorer/images/logo_32_trans.gif System
}
