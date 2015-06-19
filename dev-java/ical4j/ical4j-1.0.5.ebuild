# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ical4j/ical4j-1.0.5.ebuild,v 1.5 2015/04/21 18:37:21 pacho Exp $

EAPI="5"

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="a Java library for handling iCalendar data streams"
HOMEPAGE="http://ical4j.sourceforge.net/"
MY_PV=${PV/_/-}
MY_P=${PN}-${MY_PV}
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"

COMMON_DEP="
	dev-java/commons-logging:0
	dev-java/commons-codec:0
	dev-java/commons-lang:2.1
	dev-java/backport-util-concurrent:0"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	dev-java/emma:0
	${COMMON_DEP}"

S=${WORKDIR}/${MY_P}

java_prepare() {
	epatch "${FILESDIR}"/${PV}-build.xml.patch
	rm -v lib/*.jar || die "rm jar failed"
	#mkdir bin || die "mkdir bin failed"
	java-pkg_filter-compiler jikes
}

EANT_ANT_TASKS="emma"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_BUILD_TARGET="package"
EANT_GENTOO_CLASSPATH="commons-logging,commons-codec,commons-lang-2.1,backport-util-concurrent"
EANT_EXTRA_ARGS="-Demma.dir=/usr/share/emma/lib/ -Dsource.dir=src/main/java"

RESTRICT="test"
# two tests fail with maven, they work in HEAD

src_install() {
	java-pkg_dojar build/*.jar
	dodoc README AUTHORS CHANGELOG etc/FAQ \
		etc/TODO etc/standard_deviations.txt
	use doc && java-pkg_dojavadoc docs/api
	use source && java-pkg_dosrc src/main/java/net
	use examples && java-pkg_doexamples etc/samples
}
