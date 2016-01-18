# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# We currently download the Javadoc documentation.
# It could optionally be built using the Ant build file.
# testdata.jar and icudata.jar do not contain *.class files but *.res files
# These *.res data files are needed to built the final jar
# They do not need to be installed however as they will already be present in icu4j.jar

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2 java-osgi

DESCRIPTION="ICU4J is a set of Java libraries providing Unicode and Globalization support"
MY_PV=${PV//./_}

SRC_URI="http://download.icu-project.org/files/${PN}/${PV}/${PN}-${MY_PV}-src.jar
	doc? ( http://download.icu-project.org/files/${PN}/${PV}/${PN}-${MY_PV}-docs.jar )"

HOMEPAGE="http://www.icu-project.org/"
LICENSE="icu"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"

RDEPEND=">=virtual/jre-1.4"

# build.xml does file version detection that fails for 1.7
# https://bugs.gentoo.org/show_bug.cgi?id=213555
DEPEND="|| ( =virtual/jdk-1.6* =virtual/jdk-1.5* =virtual/jdk-1.4* )
	app-arch/unzip"

# test curently disabled
#DEPEND="test? ( || ( =virtual/jdk-1.5* =virtual/jdk-1.4* ) )
#	!test? ( || ( =virtual/jdk-1.6* =virtual/jdk-1.5* =virtual/jdk-1.4* ) )

IUSE="doc test"

RESTRICT="test"

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
	java-osgi_newjar-fromfile --no-auto-version "${PN}.jar" "${FILESDIR}/icu4j-${PV}-manifest" \
		"International Components for Unicode for Java (ICU4J)"
	java-pkg_dojar "${PN}-charsets.jar"

	use doc && dohtml -r readme.html docs/*
	use source && java-pkg_dosrc src/*
}

# Following tests will fail in Sun JDK 6 (at least):
# toUnicode: http://bugs.icu-project.org/trac/ticket/5663
# TimeZoneTransitionAdd: http://bugs.icu-project.org/trac/ticket/5887
# These are bugs in the tests themselves, not in the library

src_test() {
	# Tests currently fail, disabled for now. Need to investigate (tests work in icu4j-4.0)
	#eant check
	einfo "Tests currently disabled."
}
