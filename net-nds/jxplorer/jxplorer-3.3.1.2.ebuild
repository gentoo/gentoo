# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2 prefix virtualx

DESCRIPTION="A fully functional ldap browser written in Java"
HOMEPAGE="http://jxplorer.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-project.zip"
LICENSE="CAOSL"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

CDEPEND="
	>=dev-java/javahelp-2.0.02_p46:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.5"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.5
	test? ( dev-java/junit:0 )"

S="${WORKDIR}/${PN}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="javahelp"
EANT_TEST_ANT_TASKS="ant-junit"

src_prepare() {
	epatch "${FILESDIR}"/3.3-disable-jxworkbench.patch

	rm -v jars/*.jar || die
	sed -i -e 's/<fileset dir="${jasper}.*//g' "${S}/build.xml" || die

	if use test; then
		EANT_GENTOO_CLASSPATH_EXTRA=$(java-pkg_getjars --build-only junit)
	else
		find . -iname '*Test*.java' -delete || die
	fi
}

src_test() {
	VIRTUALX_COMMAND="java-pkg-2_src_test" virtualmake
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
