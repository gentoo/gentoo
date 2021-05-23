# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PN="${PN}_src"

DESCRIPTION="Calendar and task tracker, written in Java"
HOMEPAGE="http://borg-calendar.sourceforge.net/"
SRC_URI="mirror://sourceforge/borg-calendar/borg%201.7/BORG%20${PV}/${MY_PN}_$(ver_rs 1- _).zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/javahelp:0
	dev-java/oracle-javamail:0"
RDEPEND="${CDEPEND}
	virtual/jre:1.8
	dev-db/hsqldb:0
	dev-java/jgoodies-looks:2.6"
DEPEND="${CDEPEND}
	virtual/jdk:1.8"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_PN}/BORGCalendar"

src_prepare() {
	default
	# Upstream is dead and we already have dev-java/jcalendar
	# but it's not the same thing.
	find -name '*.jar' -! -name 'jcalendar.jar' \
		-exec rm -v {} + || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

EANT_BUILD_XML="ant/build.xml"
EANT_BUILD_TARGET="borg-jar help-jar"
EANT_GENTOO_CLASSPATH="javahelp oracle-javamail"

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_dojar build/lib/${PN}help.jar
	java-pkg_dojar lib/jcalendar.jar
	java-pkg_register-dependency hsqldb,jgoodies-looks-2.6

	java-pkg_dolauncher ${PN} --main net.sf.borg.control.Borg

	use doc && java-pkg_dojavadoc docs
	use doc && java-pkg_dosrc src/*
}
