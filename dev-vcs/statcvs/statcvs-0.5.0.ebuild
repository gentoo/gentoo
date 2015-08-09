# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="StatCVS generates HTML reports from CVS repository logs"
HOMEPAGE="http://statcvs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.zip"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

COMMON_DEPEND="
	dev-java/jcommon:1.0
	>=dev-java/jfreechart-1.0.11:1.0
	dev-java/jdom:1.0
	dev-java/ant-core:0"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	test? ( dev-java/ant-junit:0 )
	${COMMON_DEPEND}"

RDEPEND=">=virtual/jre-1.4
	dev-vcs/cvs
	dev-java/jtreemap:0
	${COMMON_DEPEND}"

EANT_BUILD_TARGET="compile copyfiles jar"

java_prepare() {
	epatch "${FILESDIR}"/${P}-build.xml.patch
	epatch "${FILESDIR}"/${PN}-0.4.0-external-jtreemap.patch

	einfo "Removing bundled jars."
	find . -name "*.jar" -print -delete

	cd "${S}"/lib || die
	java-pkg_jar-from jcommon-1.0 jcommon.jar jcommon-1.0.6.jar
	java-pkg_jar-from jfreechart-1.0 jfreechart.jar jfreechart-1.0.3.jar
	java-pkg_jar-from jdom-1.0 jdom.jar
	java-pkg_jar-from ant-core ant.jar
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_dolauncher ${PN} --main net.sf.statcvs.Main

	use doc && java-pkg_dohtml -r doc/*
	use source && java-pkg_dosrc src/net
}

src_test() {
	java-pkg_jar-from --into lib junit
	ANT_TASKS="ant-junit" eant test
}

pkg_postinst() {
	elog "For instructions on how to use StatCVS see"
	elog "http://statcvs.sourceforge.net/manual/"
	elog "You need to regenerate statistics"
	elog "if you update dev-java/jtreemap"
}
