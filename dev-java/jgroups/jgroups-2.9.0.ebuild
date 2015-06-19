# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jgroups/jgroups-2.9.0.ebuild,v 1.5 2014/08/10 20:18:14 slyfox Exp $

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PN="JGroups"
MY_PV="${PV/_p/-sp}"
MY_P="${MY_PN}-${MY_PV}.GA"
DESCRIPTION="JGroups is a toolkit for reliable multicast communication"
SRC_URI="mirror://sourceforge/javagroups/${MY_P}.src.zip"
HOMEPAGE="http://www.jgroups.org/javagroupsnew/docs/"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""
RDEPEND=">=virtual/jre-1.5
	dev-java/bsh:0
	dev-java/log4j:0
	java-virtuals/jmx"

DEPEND=">=virtual/jdk-1.5
	${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_P}.src

java_prepare() {
	# bug #305929
	epatch "${FILESDIR}/2.9.0-ant-1.8-compat.patch"

	cd "${S}/lib" || die
	rm -v *.jar || die

	java-pkg_jar-from bsh
	java-pkg_jar-from log4j
	java-pkg_jar-from --virtual jmx

	# Needed for unit tests
	#java-pkg_jar-from --build-only junit
	# One unit tests needs this
	#java-pkg_jar-from --build-only bcprov

	# Just get rid of these as they are of no use to us as we don't install them
	# Always tries to compile them.
	#if ! use test; then
		rm -vr "${S}"/tests/{junit,other,junit-functional}/org || die
		rm -v "${S}/src/org/jgroups/util/JUnitXMLReporter.java" || die
	#fi
}

JAVA_ANT_ENCODING="ISO-8859-1"

# The jar target generates jgroups-all.jar that has the demos and tests in it
EANT_BUILD_TARGET="jgroups-core.jar"

src_install() {
	java-pkg_dojar dist/jgroups-*.jar
	dodoc CREDITS README || die

	if use doc; then
		java-pkg_dojavadoc dist/javadoc
		insinto /usr/share/doc/${PF}
		doins -r doc/* || die
	fi
	use source && java-pkg_dosrc src/*

}

RESTRICT="test"
# A lot of these fail. Don't know status in 2.7
# as need testng in main tree first.
src_test() {
	# run the report target for nice html pages
	ANT_TASKS="ant-junit" eant unittests-xml
}
