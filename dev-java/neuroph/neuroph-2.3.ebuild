# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/neuroph/neuroph-2.3.ebuild,v 1.4 2012/04/13 18:52:35 ulm Exp $

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A lightweight Java neural network framework"
HOMEPAGE="http://neuroph.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}_nb.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip"

S="${WORKDIR}/${PN}_${PV}_nb/${PN}"

java_prepare() {
	find "${WORKDIR}" -iname '*.jar' -delete
	find "${WORKDIR}" -iname '*.class' -delete
}

EANT_BUILD_XML="nbbuild.xml"
EANT_BUILD_TARGET="jar"
EANT_DOC_TARGET="javadoc"
EANT_EXTRA_ARGS="-Djavadoc.additionalparam=\"\""

src_install() {
	java-pkg_dojar "dist/${PN}.jar"
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src
}
