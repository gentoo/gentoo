# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

MY_PN="AppFramework"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A small set of Java classes that simplify building desktop applications"
HOMEPAGE="https://java.net/projects/appframework/"
SRC_URI="http://dev.gentoo.org/~monsieurp/packages/${MY_P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND="dev-java/swing-worker:0"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
	dev-java/jnlp-api:0
	app-arch/unzip:0
	${CDEPEND}
	test? (
		dev-java/ant-junit:0
		dev-java/junit:0
	)"

S="${WORKDIR}/${MY_P}"

RESTRICT="test"

EANT_GENTOO_CLASSPATH="swing-worker"
JAVA_ANT_CLASSPATH_TAGS="${JAVA_ANT_CLASSPATH_TAGS} javadoc"

java_prepare() {
	rm -v lib/*.jar || die

	java-ant_rewrite-classpath nbproject/build-impl.xml

	if use doc; then
		java-ant_xml-rewrite -f "${S}"/build.xml \
			-c -e javadoc \
			-a failonerror -v no
	fi
}

src_compile() {
	EANT_GENTOO_CLASSPATH_EXTRA="$(java-pkg_getjars --build-only jnlp-api)"
	java-pkg-2_src_compile
}

src_test() {
	local cp=$(java-pkg_getjars --build-only junit):$(java-pkg_getjars swing-worker)
	ANT_TASKS="ant-junit" eant \
		-Duser.home="${T}" \
		-Drun.test.classpath="${cp}:dist/${MY_PN}.jar:build/test/classes" \
		-Dgentoo.classpath="${cp}" test
}

src_install() {
	java-pkg_newjar "${S}/dist/AppFramework.jar" "${PN}.jar"

	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/org
	use examples && java-pkg_doexamples src/examples/*
}
