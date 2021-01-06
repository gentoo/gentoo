# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Development tool to help write Java code that adheres to a coding standard"
HOMEPAGE="https://github.com/checkstyle/checkstyle"
SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x64-macos"

CP_DEPEND="
	dev-java/ant-core:0
	>=dev-java/antlr-2.7.7-r7:0
	dev-java/antlr:4
	dev-java/commons-beanutils:1.7
	>=dev-java/commons-cli-1.3:1
	dev-java/commons-logging:0
	dev-java/guava:20
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8"

S="${WORKDIR}/${PN}-${P}"
JAVA_SRC_DIR="${S}/src/main/java"

src_configure() {
	JAVA_GENTOO_CLASSPATH_EXTRA=$(java-config --tools)
}

src_compile() {
	local PKG

	PKG=com/puppycrawl/tools/checkstyle/grammars
	cd "${S}"/src/main/resources/${PKG} || die
	antlr -o "${JAVA_SRC_DIR}"/${PKG} java.g || die

	PKG+=/javadoc
	cd "${S}"/src/main/resources/${PKG} || die
	antlr4 -o "${JAVA_SRC_DIR}"/${PKG} -package ${PKG//\//.} JavadocLexer.g4 || die
	antlr4 -o "${JAVA_SRC_DIR}"/${PKG} -package ${PKG//\//.} JavadocParser.g4 || die

	cd "${S}" || die
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar src/main/resources
}

src_install() {
	java-pkg-simple_src_install
	dodoc README.md

	java-pkg_dolauncher ${PN} \
		--main com.puppycrawl.tools.checkstyle.Main

	java-pkg_dolauncher ${PN}-gui \
		--main com.puppycrawl.tools.checkstyle.gui.Main
}
