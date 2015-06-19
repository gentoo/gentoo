# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/msv/msv-20130601.ebuild,v 1.2 2015/06/16 21:02:22 chewi Exp $

EAPI=5

MY_PV="${PV:4:2}.${PV:6}"
MY_PV="${PV:0:4}.${MY_PV//0}"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Multi-Schema XML Validator, a Java tool for validating XML documents"
HOMEPAGE="https://msv.java.net/"
SRC_URI="http://search.maven.org/remotecontent?filepath=net/java/dev/${PN}/${PN}-core/${MY_PV}/${PN}-core-${MY_PV}-sources.jar"
LICENSE="BSD Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

CDEPEND="dev-java/iso-relax:0
	dev-java/relaxng-datatype:0
	dev-java/xsdlib:0"

RDEPEND="${CDEPEND}
	dev-java/xerces:2
	>=virtual/jre-1.5"

DEPEND="${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.5"

JAVA_GENTOO_CLASSPATH="iso-relax,relaxng-datatype,xsdlib"
JAVAC_ARGS="-XDignore.symbol.file"

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres "${PN}.jar" . ! -path "*/doc-files/*" ! -name "*.html"
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_register-dependency xerces-2
	java-pkg_dolauncher "${PN}" --main com.sun.msv.driver.textui.Driver
}
