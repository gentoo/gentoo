# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

WANT_ANT_TASKS="ant-trax"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java/Swing GUI components and libraries for building desktop applications"
HOMEPAGE="http://common.l2fprod.com/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="dev-java/nachocalendar:0
	dev-java/jcalendar:1.2"

DEPEND=">=virtual/jdk-1.4
	dev-java/jreleaseinfo:0
	${COMMON_DEPEND}"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

java_prepare() {
	# Do not build springrcp and sheet for now, would bloat the deps a lot;
	# potential USE flag material (spring, calendars deps).
	epatch "${FILESDIR}/${PN}-6.9.1-nodeps.patch"

	java-pkg_jar-from --build-only --into lib jreleaseinfo jreleaseinfo.jar jreleaseinfo-1.2.0.jar
}

src_compile() {
	eant init

	java-ant_bsfix_one build/build4components.xml
	java-ant_rewrite-classpath build/build4components.xml

	eant -Dgentoo.classpath="$(java-pkg_getjar nachocalendar nachocalendar.jar):$(java-pkg_getjars jcalendar-1.2)" jar
}

src_install() {
	java-pkg_dojar build/jars/*.jar

	dodoc README.txt || die
}
