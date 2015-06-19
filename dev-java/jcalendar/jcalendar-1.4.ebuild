# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jcalendar/jcalendar-1.4.ebuild,v 1.1 2014/07/14 16:42:30 ercpe Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java date chooser bean for graphically picking a date"
SRC_URI="http://www.toedter.com/download/${P}.zip"
HOMEPAGE="http://www.toedter.com/en/jcalendar/"

LICENSE="LGPL-2.1"
SLOT="1.2"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="dev-java/jgoodies-looks:2.6"

RDEPEND=">=virtual/jdk-1.4
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.4
	>=app-arch/unzip-5.50-r1
	${COMMON_DEPEND}"

S="${WORKDIR}"

RESTRICT="test"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="jgoodies-looks-2.6"
EANT_BUILD_XML="src/build.xml"
EANT_BUILD_TARGET="jar"
EANT_DOC_TARGET=""

java_prepare() {
	rm lib/*.jar || die
}

src_install() {
	java-pkg_newjar lib/${P}.jar

	dodoc readme.txt

	use doc && java-pkg_dohtml -r doc/*
	use source && java-pkg_dosrc src/com
}
