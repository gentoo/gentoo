# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/icu4j/icu4j-4.4.2.ebuild,v 1.7 2015/02/03 15:36:47 fordfrog Exp $

EAPI=5

# We currently download the Javadoc documentation.
# It could optionally be built using the Ant build file.
# testdata.jar and icudata.jar do not contain *.class files but *.res files
# These *.res data files are needed to built the final jar
# They do not need to be installed however as they will already be present in icu4j.jar

JAVA_PKG_IUSE="doc test source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A set of Java libraries providing Unicode and Globalization support"
MY_PV=${PV//./_}

SRC_URI="http://download.icu-project.org/files/${PN}/${PV}/${PN}-${MY_PV}-src.jar
	doc? ( http://download.icu-project.org/files/${PN}/${PV}/${PN}-${MY_PV}-docs.jar )"

HOMEPAGE="http://www.icu-project.org/"
LICENSE="icu"
SLOT="4.4"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

# Tests only work with JDK-1.6, severe out of memory problems appear with 1.5
DEPEND="test? ( =virtual/jdk-1.6* )
	!test? ( >=virtual/jdk-1.5 )"
RDEPEND=">=virtual/jre-1.5"

RESTRICT="ia64? ( test )"

JAVA_PKG_WANT_SOURCE="1.5"
JAVA_PKG_WANT_TARGET="1.5"
JAVA_PKG_BSFIX_NAME="build.xml common-targets.xml"

S="${WORKDIR}"

src_unpack() {
	jar -xf "${DISTDIR}/${PN}-${MY_PV}-src.jar" || die "Failed to unpack"

	if use doc; then
		mkdir docs; cd docs
		jar -xf "${DISTDIR}/${PN}-${MY_PV}-docs.jar" || die "Failed to unpack docs"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/icu4j-4.4.2-add-jdk8-to-check.patch
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
	java-pkg_dojar "${PN}.jar"
	java-pkg_dojar "${PN}-charsets.jar"
	java-pkg_dojar "${PN}-localespi.jar"

	dohtml readme.html || die
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc main/classes/*/src/com
}

src_test() {
	# bug #299082 - these tests fail with icedtea, assume too much about double<>string conversions
	sed -i '/DiagBigDecimal/d' main/tests/core/src/com/ibm/icu/dev/test/TestAllCore.java || die
	eant check
}
