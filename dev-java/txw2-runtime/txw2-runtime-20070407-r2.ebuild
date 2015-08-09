# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="TXW is a library that allows you to write XML documents"
HOMEPAGE="https://txw.dev.java.net/"
SRC_URI="https://txw.dev.java.net/files/documents/3310/54821/txw2-${PV}.zip"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

COMMON_DEP="java-virtuals/stax-api"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

S="${WORKDIR}/txw2-${PV}"

src_unpack() {

	unpack ${A}

	cd "${S}"
	rm -v *.jar || die
	cd "${S}/lib"
	rm -v *.jar || die

	java-pkg_jarfrom --build-only ant-core
	java-pkg_jarfrom --virtual stax-api

	cd "${S}"
	unzip -qq txw2-src.zip -d runtime || die unzip failed
	unzip -qq txw2c-src.zip -d compiler || die unzip failed

	cp -i "${FILESDIR}/build.xml-20070407" "${S}/build.xml" || die cp failed

}

EANT_BUILD_TARGET="runtime-jar"
EANT_DOC_TARGET=""

src_install() {
	java-pkg_newjar txw2.jar

	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc runtime/*
}
