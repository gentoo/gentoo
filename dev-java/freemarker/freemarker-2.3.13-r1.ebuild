# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION=" FreeMarker is a template engine; a generic tool to generate text output based on templates"
HOMEPAGE="http://freemarker.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="freemarker"
SLOT="2.3"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEP="
	>=dev-java/jython-2.2:0
	java-virtuals/servlet-api:2.3
	java-virtuals/servlet-api:2.4
	java-virtuals/servlet-api:2.5
	dev-java/jaxen:1.1
	dev-java/juel:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	dev-java/javacc:0"

java_prepare() {
	find -name '*.jar' -exec rm -v {} + || die

	epatch "${FILESDIR}/${P}-gentoo.patch"

	# for ecj-3.5
	java-ant_rewrite-bootclasspath auto
}

src_compile() {
	# BIG FAT WARNING:
	# clean target removes lib/ directory!!
	eant clean

	mkdir -p lib/jsp-{1.2,2.0,2.1} || die
	pushd lib >/dev/null || die
	java-pkg_jar-from --virtual --into jsp-1.2 servlet-api-2.3
	java-pkg_jar-from --virtual --into jsp-2.0 servlet-api-2.4
	java-pkg_jar-from --virtual --into jsp-2.1 servlet-api-2.5
	java-pkg_jar-from jaxen-1.1
	java-pkg_jar-from jython
	java-pkg_jar-from --build-only javacc
	java-pkg_jar-from juel
	popd >/dev/null

	eant jar $(use_doc) -Djavacc.home=/usr/share/javacc/lib
}

src_install() {
	java-pkg_dojar lib/${PN}.jar
	dodoc README.txt

	use doc && java-pkg_dojavadoc build/api
	use source && java-pkg_dosrc src/*
}
