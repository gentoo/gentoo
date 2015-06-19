# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/msv/msv-20050627-r3.ebuild,v 1.5 2012/04/15 18:39:26 vapier Exp $

EAPI=1
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 eutils java-ant-2

DESCRIPTION="Multi-Schema XML Validator, a Java tool for validating XML documents"
HOMEPAGE="http://www.sun.com/software/xml/developers/multischema/ https://msv.dev.java.net/"
SRC_URI="mirror://gentoo/${PN}.${PV}.zip"

LICENSE="BSD Apache-1.1"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	dev-java/iso-relax:0
	dev-java/relaxng-datatype:0
	dev-java/xml-commons-resolver:0
	dev-java/xerces:2
	dev-java/xsdlib:0"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${RDEPEND}"

JAVA_PKG_FILTER_COMPILER="jikes"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp -i "${FILESDIR}/build-${PVR}.xml" build.xml || die
	rm -v *.jar || die

	mkdir lib && cd lib
	java-pkg_jar-from iso-relax,relaxng-datatype,xerces-2,xml-commons-resolver,xsdlib
}

EANT_EXTRA_ARGS="-Dproject.name=${PN}"

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_dolauncher msv --main com.sun.msv.driver.textui.Driver

	dodoc README.txt ChangeLog.txt || die

	use doc && java-pkg_dojavadoc dist/doc/api
	use source && java-pkg_dosrc src/*
}
