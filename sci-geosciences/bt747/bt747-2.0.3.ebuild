# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WANT_ANT_TASKS="ant-nodeps"

inherit java-utils-2 java-pkg-2 java-ant-2

MY_PN=BT747
MY_P=${MY_PN}_${PV}

DESCRIPTION="MTK GPS Datalogger Device Control"
HOMEPAGE="http://bt747.free.fr/"
SRC_URI="mirror://sourceforge/${PN}/BT747_${PV}_full.zip"

LICENSE="GPL-3"
SLOT="1"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEP="
	>=dev-java/rxtx-2.2_pre2
	dev-java/swing-layout:1
	dev-java/jcalendar:1.2
	dev-java/jcharts
"
RDEPEND="${COMMON_DEP}
	dev-libs/glib:2[dbus]
	>=virtual/jre-1.5
"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	app-arch/unzip
"

EANT_BUILD_TARGET="dist.j2se"
EANT_EXTRA_ARGS="-Dskip.proguard=yes
	-Drxtxcomm.jar=lib/RXTXcomm.jar
	-Dswing-layout.jar=lib/swing-layout.jar
	-Djcalendar.jar=lib/jcalendar.jar"

S="${WORKDIR}"

java_prepare() {
	rm -rf dist
	cd lib
	rm -rf r* W* c* swing-* w* jca*
	java-pkg_jar-from rxtx-2
	java-pkg_jar-from swing-layout-1
	java-pkg_jar-from jcalendar-1.2
}

src_install() {
	dodoc ChangeLog.txt README.txt
	java-pkg_dojar dist/*.jar
	java-pkg_jarinto /opt/${PN}-${SLOT}/lib
	java-pkg_newjar lib/jopt-simple-2.4.1.jar jopt-simple.jar
	java-pkg_dojar lib/swingx*.jar
	java-pkg_dolauncher ${PN} --main bt747.j2se_view.BT747Main \
		--java-args="-Xmx192m"
}
