# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ognl/ognl-3.0.8.ebuild,v 1.3 2014/01/02 15:07:45 tomwij Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Object-Graph Navigation Language; an expression language for getting/setting properties of objects"
HOMEPAGE="http://www.ognl.org/"
SRC_URI="https://github.com/jkuhnert/ognl/archive/OGNL_${PV//./_}.tar.gz
	https://ognl.dev.java.net/source/browse/*checkout*/ognl/osbuild.xml"

LICENSE="Apache-1.1"
SLOT="3.0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/javassist:3"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${CDEPEND}"

S="${WORKDIR}/${PN}-OGNL_${PV//./_}"

java_prepare() {
	find -name '*.jar' -exec rm -v {} + || die

	cp "${DISTDIR}/osbuild.xml" "${S}/" || die

	sed "s/\(name=\"compile.version\" value=\"\)1.3\"/\1$(java-pkg_get-source)\"/" \
		-i osbuild.xml || die

	cd lib/build
	java-pkg_jar-from javassist-3
}

EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_newjar build/ognl-2.7.2.jar ${PN}.jar

	use doc && java-pkg_dohtml -r dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
