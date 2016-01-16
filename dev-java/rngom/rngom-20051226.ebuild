# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="RNGOM is an open-source Java library for parsing RELAX NG grammars"
HOMEPAGE="https://rngom.dev.java.net/"
SRC_URI="https://rngom.dev.java.net/files/documents/1647/26424/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

COMMON_DEP="dev-java/relaxng-datatype
	dev-java/xsdlib"

DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

src_unpack() {

	unpack ${A}

	cd "${S}"
	rm -v *.jar || die
	mkdir lib || die

	cd lib/
	java-pkg_jarfrom relaxng-datatype
	java-pkg_jarfrom xsdlib

	cp "${FILESDIR}/build.xml-${PV}" "${S}/build.xml" || die "cp failed"

}

src_compile() {
	eant jar
}

src_install() {

	java-pkg_dojar "${PN}.jar"

	use source && java-pkg_dosrc src/*
	use doc && java-pkg_dojavadoc javadoc

}
