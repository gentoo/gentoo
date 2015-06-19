# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/poi/poi-3.0.2-r1.ebuild,v 1.6 2011/12/19 11:08:31 sera Exp $

EAPI=1
JAVA_PKG_IUSE="doc examples source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Java API To Access Microsoft Format Files"
HOMEPAGE="http://poi.apache.org/"
RELEASE_DATE="20080204"
SRC_URI="mirror://apache/poi/release/src/${PN}-src-${PV}-FINAL-${RELEASE_DATE}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"

COMMON_DEPEND="
	>=dev-java/commons-beanutils-1.7:1.7
	>=dev-java/commons-lang-2.1:2.1
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
	# Patch that adds official fix for detection of custom date/time formats
	# See bug: http://issues.apache.org/bugzilla/show_bug.cgi?id=44373
	epatch "${FILESDIR}/${P}-isADateFormat.patch"
	use test && epatch "${FILESDIR}/${P}-isADateFormatTest.patch"

	find -name "*.jar" | xargs rm -v

	cd "${S}/lib"
	java-pkg_jar-from commons-logging commons-logging.jar commons-logging-1.1.jar
	use test && java-pkg_jar-from --build-only junit junit.jar junit-3.8.1.jar

	cd "${S}/src/contrib/lib"
	java-pkg_jar-from commons-beanutils-1.7 commons-beanutils.jar commons-beanutils-1.7.0.jar
	java-pkg_jar-from commons-lang-2.1 commons-lang.jar commons-lang-2.1.jar

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
	use doc && java-pkg_dojavadoc build/tmp/site/build/site/*
	use examples && java-pkg_doexamples src/examples/* src/scratchpad/examples/*
	use source && java-pkg_dosrc src/contrib/src/org src/java/org src/scratchpad/src/org

	cd build/dist
	local VERSION=$(get_version_component_range 1-2)
	java-pkg_newjar poi-scratchpad-${VERSION}* ${PN}-scratchpad.jar
	java-pkg_newjar poi-contrib-${VERSION}* ${PN}-contrib.jar
	java-pkg_newjar poi-${VERSION}* ${PN}.jar
}
