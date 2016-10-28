# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit java-pkg-2

MY_PN=LanguageTool
MY_P=${MY_PN}-${PV}

DESCRIPTION="a proof-reading tool for many languages"
HOMEPAGE="http://www.languagetool.org/"
SRC_URI="http://www.languagetool.org/download/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.8
	dev-java/commons-cli:1
	dev-java/commons-io:1
	dev-java/commons-lang:2.1
	dev-java/commons-logging:0
	dev-java/guava:18
	dev-java/hamcrest-core:1.3
	dev-java/jna:0
	dev-java/jcommander:0
	dev-java/slf4j-api:0
	dev-java/slf4j-nop:0
"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_P}

src_prepare() {
	java-pkg-2_src_prepare
	default
}

src_compile() { :; }

src_install() {
	insinto /usr/share/${PN}
	doins *.jar
	doins -r org META-INF

	cat >>"${T}/${PN}" <<-EOF
		#!/bin/sh
		cd "${EROOT}usr/share/${PN}"
		java -jar ${PN}-commandline.jar \$@
	EOF

	cat >>"${T}/${PN}-gui" <<-EOF
		#!/bin/sh
		cd "${EROOT}usr/share/${PN}"
		java -jar ${PN}.jar \$@
	EOF
	exeinto /usr/bin
	doexe "${T}"/${PN} "${T}"/${PN}-gui

	dodoc CHANGES.md README.md

	pushd libs >/dev/null || die
	rm {commons-io,commons-lang,commons-logging,jcommander,jna,junit}.jar || die
	java-pkg_jarinto /usr/share/${PN}/libs
	java-pkg_jar-from commons-io-1 commons-io.jar
	java-pkg_jar-from commons-lang-2.1 commons-lang.jar
	java-pkg_jar-from commons-logging commons-logging.jar
	java-pkg_jar-from commons-cli-1 commons-cli.jar
	java-pkg_jar-from guava-18 guava.jar
	java-pkg_jar-from hamcrest-core-1.3 hamcrest-core.jar
	java-pkg_jar-from jcommander jcommander.jar
	java-pkg_jar-from jna jna.jar
	java-pkg_jar-from slf4j-api slf4j-api.jar
	java-pkg_jar-from slf4j-nop slf4j-nop.jar
	java-pkg_dojar *.jar
	popd >/dev/null || die
}
