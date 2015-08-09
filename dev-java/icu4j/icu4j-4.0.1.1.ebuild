# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

# We currently download the Javadoc documentation.
# It could optionally be built using the Ant build file.
# testdata.jar and icudata.jar do not contain *.class files but *.res files
# These *.res data files are needed to built the final jar
# They do not need to be installed however as they will already be present in icu4j.jar

JAVA_PKG_IUSE="doc test source"

inherit java-pkg-2 java-ant-2 java-osgi

DESCRIPTION="A set of Java libraries providing Unicode and Globalization support"
MY_PV=${PV//./_}

SRC_URI="http://download.icu-project.org/files/${PN}/${PV}/${PN}-${MY_PV}-src.jar
	doc? ( http://download.icu-project.org/files/${PN}/${PV}/${PN}-${MY_PV}-docs.jar )"

HOMEPAGE="http://www.icu-project.org/"
LICENSE="icu"
SLOT="4"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND=">=virtual/jre-1.4"

# build.xml does file version detection that fails for 1.7
# http://bugs.gentoo.org/show_bug.cgi?id=213555
DEPEND="test? ( =virtual/jdk-1.6* )
	!test? ( || ( =virtual/jdk-1.6* =virtual/jdk-1.5* =virtual/jdk-1.4* ) )
	app-arch/unzip"

RESTRICT="ia64? ( test )
	x86-fbsd? ( test )"
JAVA_PKG_WANT_SOURCE="1.4"
JAVA_PKG_WANT_TARGET="1.4"

S="${WORKDIR}"

src_unpack() {
	jar -xf "${DISTDIR}/${PN}-${MY_PV}-src.jar" || die "Failed to unpack"

	if use doc; then
		mkdir docs; cd docs
		jar -xf "${DISTDIR}/${PN}-${MY_PV}-docs.jar" || die "Failed to unpack docs"
	fi
}

src_compile() {
	# Classes extending CharsetICU not implementing Comparable
	# Breaks with ecj on jdk 1.5+, javac doesn't mind - Sun's hack?
	# Restricting to javac (didn't even care to try jikes) is better
	# than forcing 1.4
	java-pkg_force-compiler javac
	eant jar || die "Compile failed"
}

src_install() {
	java-osgi_newjar-fromfile "${PN}.jar" "${FILESDIR}/icu4j-4.0-manifest" \
		"International Components for Unicode for Java (ICU4J)"
	java-pkg_dojar "${PN}-charsets.jar"

	use doc && dohtml -r readme.html docs/*
	use source && java-pkg_dosrc src/*
}

# Tests only work with JDK-1.6, severe out of memory problems appear with 1.5

src_test() {
	# bug #299082 - these tests fail with icedtea, assume too much about double<>string conversions
	sed -i '/DiagBigDecimal/d' src/com/ibm/icu/dev/test/TestAll.java || die
	eant check
}
