# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Tool to validate IDPF EPUB files"
HOMEPAGE="https://code.google.com/p/epubcheck/"
SRC_URI="https://${PN}.googlecode.com/files/${PN}-src-${PV}.zip"

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEP="dev-java/jigsaw:0
	dev-java/saxon:6.5"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/${PN}"

src_prepare() {
	rm -f lib/*.jar

	java-pkg_jar-from --into lib/ jigsaw
	java-pkg_jar-from --into lib/ saxon-6.5

	cd lib/
	ln -s $(java-config --tools)
}

src_compile() {
	eant buildJar
}

src_test() {
	java -cp "$(java-pkg_getjars jigsaw,saxon-6.5):dist/${P}.jar" \
		com.adobe.epubcheck.autotest.AutoTest testdocs/general/tests.xml testdocs/general/ \
		|| die "tests failed"
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar

	java-pkg_dolauncher ${PN} --main com.adobe.epubcheck.tool.Checker

	dodoc README.txt
}
