# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit java-pkg-2

MY_PN=LanguageTool
MY_P=${MY_PN}-${PV}

DESCRIPTION="A proof-reading tool for many languages"
HOMEPAGE="https://www.languagetool.org/"
SRC_URI="https://www.languagetool.org/download/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CP_DEPEND="
	dev-java/commons-cli:1
	dev-java/commons-collections:4
	dev-java/commons-io:1
	dev-java/commons-lang:2.1
	dev-java/commons-logging:0
	dev-java/guava:20
	dev-java/hamcrest-core:1.3
	dev-java/jcommander:0
	dev-java/jna:4
	dev-java/slf4j-api:0
	dev-java/slf4j-nop:0
"

RDEPEND=">=virtual/jre-1.8
	${CP_DEPEND}"

DEPEND="app-arch/unzip"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default
	rm libs/commons-{cli,collections4,io,lang,logging}.jar || die
	rm libs/{hamcrest-core,guava,jcommander,jna,junit,slf4j-api}.jar || die

	# Loads of bundled stuff :(
	#java-pkg-2_src_prepare
}

src_compile() { :; }

src_install() {
	java-pkg_dojar *.jar libs/*.jar

	local DIR=/usr/share/${PN}/lib/language-modules
	java-pkg_addcp "${EPREFIX}${DIR}"
	insinto ${DIR}
	doins -r org META-INF

	java-pkg_dolauncher ${PN} --main org.${PN}.commandline.Main
	java-pkg_dolauncher ${PN}-gui --main org.${PN}.gui.Main

	dodoc CHANGES.md README.md

	unset MY_DEPEND
	java-pkg_gen-cp MY_DEPEND
	java-pkg_register-dependency "${MY_DEPEND}"
}
