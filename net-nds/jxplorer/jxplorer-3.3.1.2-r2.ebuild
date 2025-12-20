# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit"

inherit desktop java-pkg-2 java-pkg-simple prefix

DESCRIPTION="Fully functional LDAP browser written in Java"
HOMEPAGE="https://jxplorer.org/"
SRC_URI="https://downloads.sourceforge.net/project/jxplorer/jxplorer/version%20${PV}/${P}-project%20.tar.bz2"
S="${WORKDIR}/${PN}"

LICENSE="CAOSL"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="app-arch/unzip"
CP_DEPEND=">=dev-java/javahelp-2.0.02_p46:0"
# needs java stuff that is missing in java > 1.8 os has to be restricted
DEPEND="${CP_DEPEND}
	virtual/jdk:1.8
	test? ( dev-java/junit:0 )
"
RDEPEND="${CP_DEPEND}
	virtual/jre:1.8
"

JAVA_MAIN_CLASS="com.ca.directory.jxplorer.JXplorer"
JAVA_SRC_DIR="main/src"
JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_SRC_DIRS="test/src"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir main test || die
	find src -type f \
		! -path '**/*Test.java' \
		! -path '**/*Test*.java' \
		| xargs cp --parent -t main || die

	find src -type f \
		\( -path '**/*Test.java' \
		-o -path '**/*Test*.java' \) \
		| xargs cp --parent -t test || die

	rm -r src || die
}

src_test() {
#	VIRTUALX_COMMAND="java-pkg-2_src_test" virtx emake -j1
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install

	insinto /usr/share/${PN}
	doins -r icons images htmldocs language templates plugins security.default csvconfig.txt.default

	dodoc README*.TXT

	# By default the config dir is ${HOME}/jxplorer
	java-pkg_dolauncher ${PN} \
		--main com.ca.directory.jxplorer.JXplorer \
		--pwd '"${HOME}/.jxplorer"' \
		-pre "${FILESDIR}/${PN}-3-pre"

	eprefixify "${ED}/usr/bin/${PN}"

	make_desktop_entry ${PN} JXplorer /usr/share/jxplorer/images/logo_32_trans.gif System
}
