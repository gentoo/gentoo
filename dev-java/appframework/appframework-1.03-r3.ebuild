# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/appframework/appframework-1.03-r3.ebuild,v 1.3 2015/01/06 20:27:03 zlogene Exp $

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

MY_PN="AppFramework"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A small set of Java classes that simplify building desktop applications"
HOMEPAGE="https://appframework.dev.java.net/"
SRC_URI="https://appframework.dev.java.net/downloads/${MY_P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

COMMON_DEP="dev-java/swing-worker:0"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.5
	dev-java/jnlp-api:0
	app-arch/unzip:0
	${COMMON_DEP}
	test?
	(
		dev-java/junit:0
		dev-java/ant-junit:0
	)"

S="${WORKDIR}/${MY_P}"

RESTRICT="test"

EANT_GENTOO_CLASSPATH="swing-worker"
JAVA_ANT_CLASSPATH_TAGS="${JAVA_ANT_CLASSPATH_TAGS} javadoc"

java_prepare() {
	rm -v lib/*.jar || die

	java-ant_rewrite-classpath
	java-ant_rewrite-classpath nbproject/build-impl.xml
}

src_compile() {
	EANT_GENTOO_CLASSPATH_EXTRA="$(java-pkg_getjars --build-only jnlp-api)"
	java-pkg-2_src_compile
}

src_install() {
	java-pkg_newjar "${S}/dist/AppFramework.jar" "${PN}.jar"

	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/org
	use examples && java-pkg_doexamples src/examples/*
}

src_test() {
	local cp=$(java-pkg_getjars --build-only junit):$(java-pkg_getjars swing-worker)
	ANT_TASKS="ant-junit" eant \
		-Duser.home="${T}" \
		-Drun.test.classpath="${cp}:dist/${MY_PN}.jar:build/test/classes" \
		-Dgentoo.classpath="${cp}" test
}
