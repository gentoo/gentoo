# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="a client, protocol, and server for running Java apps without incurring the JVM startup overhead"
HOMEPAGE="http://martiansoftware.com/nailgun/index.html"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=">=virtual/jre-1.4
	!app-editors/ng"
DEPEND=">=virtual/jdk-1.4
	dev-java/java-getopt:1
	dev-java/bcel:0
	dev-java/jakarta-oro:2.0
	dev-java/log4j:0
	app-arch/unzip
	dev-java/junit:0
	test? (
		dev-java/ant-junit:0
	)"

#need jcoverage
RESTRICT="test"

java_prepare() {
	rm -vf ng* beansh
	find . -iname '*.jar' -delete

	epatch "${FILESDIR}/${PV}-r1-Makefile.patch"

	sed -i '/<arg line="ng.exe/d' build.xml || die
	sed -i 's/depends="test"/depends="compile"/' build.xml || die

	java-pkg_jar-from --into tools/lib --build-only java-getopt-1 \
		gnu.getopt.jar java-getopt-1.0.10.jar
	java-pkg_jar-from --into tools/lib --build-only junit junit.jar
	java-pkg_jar-from --into tools/lib --build-only bcel bcel.jar \
		bcel-5.1.jar
	java-pkg_jar-from --into tools/lib --build-only jakarta-oro-2.0 \
		jakarta-oro.jar jakarta-oro-2.0.8.jar
	java-pkg_jar-from --into tools/lib --build-only log4j log4j.jar \
		log4j-1.2.8.jar
}

src_test() {
	WANT_TASKS="ant-junit" eant test
}

src_install() {
	dobin ng
	# Should we have a dolauncher?

	java-pkg_newjar "dist/${P}.jar"
	use doc && java-pkg_dojavadoc docs/api
	use source && java-pkg_dosrc src/java/prod/*
}
