# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=1
JAVA_PKG_IUSE="doc examples source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Java API To Access Microsoft Format Files"
HOMEPAGE="http://poi.apache.org/"
RELEASE_DATE="20081019"
SRC_URI="mirror://apache/poi/release/src/${PN}-src-${PV}-FINAL-${RELEASE_DATE}.tar.gz"

LICENSE="Apache-2.0"
SLOT="3.2"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"

COMMON_DEPEND="
	>=dev-java/commons-logging-1.1"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEPEND}
	test? ( dev-java/ant-junit )"

S=${WORKDIR}/${P}-FINAL

src_unpack() {
	unpack ${A}

	cd "${S}"
	find -name "*.jar" | xargs rm -v

	cd "${S}/lib"
	java-pkg_jar-from commons-logging commons-logging.jar commons-logging-1.1.jar
	use test && java-pkg_jar-from --build-only junit junit.jar junit-3.8.1.jar

	java-pkg_filter-compiler jikes
}

src_compile() {
	# the same target compiles the source and the test so we just mess with
	# the source directory
	eant jar $(use_doc javadocs) -Ddisconnected=true \
		$(use !test && echo -Dmain.src.test=legal -Dscratchpad.src.test=legal)
}

src_test() {
	ANT_TASKS="ant-junit" eant test -Ddisconnected=true
}

src_install() {
	use doc && java-pkg_dojavadoc build/tmp/site/build/site/apidocs
	use examples && java-pkg_doexamples src/examples/* src/scratchpad/examples/*
	use source && java-pkg_dosrc src/contrib/src/org src/java/org src/scratchpad/src/org

	cd build/dist || die "Cannot change to dist directory"
	java-pkg_newjar poi-scratchpad-${PV}* ${PN}-scratchpad.jar
	java-pkg_newjar poi-contrib-${PV}* ${PN}-contrib.jar
	java-pkg_newjar poi-${PV}* ${PN}.jar
}
