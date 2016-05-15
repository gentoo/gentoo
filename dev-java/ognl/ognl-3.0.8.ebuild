# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Object-Graph Navigation Language: get/set properties of objects"
HOMEPAGE="http://www.ognl.org/"
SRC_URI="https://github.com/jkuhnert/ognl/archive/OGNL_${PV//./_}.tar.gz
	https://ognl.dev.java.net/source/browse/*checkout*/ognl/osbuild.xml"

LICENSE="Apache-1.1"
SLOT="3.0"
KEYWORDS="amd64 x86"

CDEPEND="dev-java/javassist:3"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.6"

S="${WORKDIR}/${PN}-OGNL_${PV//./_}"

java_prepare() {
	java-pkg_clean

	cp "${DISTDIR}/osbuild.xml" "${S}/" || die

	sed "s/\(name=\"compile.version\" value=\"\)1.3\"/\1$(java-pkg_get-source)\"/" \
		-i osbuild.xml || die

	cd lib/build || die

	java-pkg_jar-from javassist-3
}

EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_newjar build/ognl-2.7.2.jar "${PN}.jar"

	use doc && java-pkg_dohtml -r dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
