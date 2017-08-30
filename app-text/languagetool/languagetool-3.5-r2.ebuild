# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2

MY_PN=LanguageTool
MY_P=${MY_PN}-${PV}

DESCRIPTION="A proof-reading tool for many languages"
HOMEPAGE="http://www.languagetool.org/"
SRC_URI="http://www.languagetool.org/download/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/commons-cli:1
	dev-java/commons-collections:4
	dev-java/commons-io:1
	dev-java/commons-lang:2.1
	dev-java/commons-logging:0
	dev-java/guava:20
	dev-java/hamcrest-core:1.3
	dev-java/jackson:2
	dev-java/jackson-databind:2
	dev-java/jcommander:0
	dev-java/jna:4
	dev-java/slf4j-api:0
	dev-java/slf4j-nop:0
"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8"

DEPEND="
	${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.8"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	rm -v libs/{commons,hamcrest,guava,jackson,jcommander,jna,junit,slf4j}*.jar || die

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

	unset MY_DEPEND
	java-pkg_gen-cp MY_DEPEND
	java-pkg_register-dependency "${MY_DEPEND}"
}
