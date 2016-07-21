# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Themeable and easy to use TV Guide - written in Java"
HOMEPAGE="http://www.tvbrowser.org/"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}_src.zip"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
IUSE=""

COMMON_DEP="dev-java/bsh:0
	dev-java/commons-codec:0
	dev-java/commons-lang:3.1
	dev-java/commons-net:0
	dev-java/jakarta-oro:2.0
	dev-java/jgoodies-common:1.8
	dev-java/jgoodies-forms:1.8
	dev-java/jgoodies-looks:2.6
	dev-java/l2fprod-common:0
	dev-java/htmlparser-org:0
	dev-java/log4j:0
	dev-java/skinlf:0
	dev-java/xalan:0
	dev-java/opencsv:0
	dev-java/texhyphj:0
	dev-java/trident:0
	x11-libs/libXt
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libXext
	x11-libs/libXtst
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp"

DEPEND="${COMMON_DEP}
	app-arch/unzip
	>=virtual/jdk-1.6"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.6"

java_prepare() {
	epatch "${FILESDIR}"/${PV}-*.patch

	rm -v lib/{bsh-,commons,jgoodies,l2fprod-common-tasks,skinlf,stax,htmlparser,opencsv,trident,texhyphj,jRegistryKey}*.jar

	find deployment -name '*.jar' -delete || die
	find . -name '*.class' -delete || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="bsh
	commons-codec
	commons-lang-3.1
	jgoodies-common-1.8
	jgoodies-forms-1.8
	jgoodies-looks-2.6
	l2fprod-common
	skinlf
	htmlparser-org
	opencsv
	texhyphj"
EANT_BUILD_TARGET="runtime-linux"
EANT_DOC_TARGET="public-doc"

src_install() {
	java-pkg_dojar runtime/${PN}_linux/${PN}.jar
	java-pkg_dojar lib/substance-6.1.jar
	java-pkg_register-dependency trident,opencsv

	insinto /usr/share/${PN}
	doins -r runtime/${PN}_linux/{imgs,icons,plugins,infothemes}
	doins runtime/${PN}_linux/linux.properties

	insinto /usr/share/${PN}/themepacks
	doins themepacks/themepack.zip

	java-pkg_dolauncher "tvbrowser" \
		--main tvbrowser.TVBrowser \
		--pwd /usr/share/${PN} \
		--java_args " -Dpropertiesfile=/usr/share/${PN}/linux.properties"

	make_desktop_entry ${PN} "TV-Browser" \
		/usr/share/tvbrowser/imgs/tvbrowser128.png "AudioVideo;TV;Video"

	use source && java-pkg_dosrc src/*
	use doc && java-pkg_dojavadoc doc
}
