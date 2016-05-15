# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc examples source"
inherit java-pkg-2 java-ant-2 eutils versionator

MY_P="${PN}$(replace_all_version_separators -)"
DESCRIPTION="A collection of tools for processing XML documents: XSLT processor, XSL library, parser"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
HOMEPAGE="http://saxon.sourceforge.net/"

LICENSE="MPL-1.1"
SLOT="6.5"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP="dev-java/jdom:0"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}

	unzip -qq source.zip -d src || die "failed to unpack"

	cp "${FILESDIR}/build-${PV}.xml" build.xml || die

	rm -v *.jar || die
	rm -rf doc/api || die
	rm samples/java/*.class || die
	mkdir lib && cd lib
	java-pkg_jar-from jdom
}

src_compile() {
	java-pkg_filter-compiler jikes

	eant -Dproject.name=${PN} jar $(use_doc)
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	if use doc; then
		java-pkg_dojavadoc dist/doc/api
		dohtml -r doc/*
	fi
	use examples && java-pkg_doexamples samples
	use source && java-pkg_dosrc src/*
}
