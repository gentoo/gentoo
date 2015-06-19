# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-grant/commons-grant-1.0.ebuild,v 1.2 2014/08/10 20:10:54 slyfox Exp $

# Note: Upstream is dead... only place to find is on the ibiblio maven repo
# and on jpackage.org

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils rpm
MY_PN="jakarta-${PN}"
SNAPSHOT_DATE="20040118"
MY_PV="${PV%%_*}.b5.cvs${SNAPSHOT_DATE}"
MY_PV="${MY_PV//_beta/.b}"
MY_P="${MY_PN}-${MY_PV}"
JPACKAGE_REVISION="4"

DESCRIPTION="A small collection of hacks to make using Ant in an embedded envinronment much easier"
# This link seems dead, but I don't have anywhere else to turn
HOMEPAGE="http://jakarta.apache.org/commons/sandbox/grant/"
SRC_URI="mirror://jpackage/1.6/generic/free/SRPMS/${MY_P}-${JPACKAGE_REVISION}jpp.src.rpm"

DEPEND=">=virtual/jdk-1.3"
RDEPEND=">=virtual/jre-1.3
	dev-java/ant-core"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc source"

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack(){
	rpm_src_unpack
	cd "${S}"
	epatch "${FILESDIR}"/${P}_beta5-gentoo.diff

	mkdir -p target/lib
	cd target/lib
	java-pkg_jar-from ant-core
}

src_install(){
	java-pkg_newjar target/${PN}-1.0-beta-4.jar ${PN}.jar
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}

#No unit tests although the target exists
#src_test() {
#	eant test || die "Test failed"
#}
