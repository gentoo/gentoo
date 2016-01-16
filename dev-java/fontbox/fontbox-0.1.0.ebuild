# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2

DESCRIPTION="An open source Java library for parsing font files"
HOMEPAGE="http://www.fontbox.org/"
MY_PN=FontBox
MY_P=${MY_PN}-${PV}
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"

IUSE="doc source"

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
		dev-java/ant-core
		app-arch/unzip
		source? ( app-arch/zip )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v lib/*.jar
}

EANT_BUILD_TARGET="package"

#These are not in the zip
#Probably only in CVS
#src_test() {
#	eant junit
#}

src_install() {
	java-pkg_newjar ./lib/${MY_P}.jar ${PN}.jar
	mv docs/javadoc . || die
	dohtml -r docs/*
	use doc && java-pkg_dojavadoc javadoc/
	mv javadoc docs
	use source && java-pkg_dosrc src/org
}
