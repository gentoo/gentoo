# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit base java-pkg-2 java-ant-2

DESCRIPTION="Speex speech codec library for Java"
HOMEPAGE="http://jspeex.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/ant-core:0"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.4"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.4
	dev-java/junit:0
	test? (
		dev-java/ant-junit:0
		dev-java/ant-trax:0
	)"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="ant-core"
EANT_BUILD_TARGET="package"

S="${WORKDIR}/${PN}"

java_prepare() {
	epatch "${FILESDIR}"/${P}-remove-junit-report.patch
	epatch "${FILESDIR}"/${P}-remove-proguard-taskdef.patch

	find . -name "*.jar" -delete || die "Failed to remove bundled libraries."

	cd lib || die
	java-pkg_jar-from --build-only junit
}

src_test() {
	ANT_TASKS="ant-junit ant-trax" eant test
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	dodoc README TODO

	use doc && java-pkg_dojavadoc doc/javadoc
	use source && java-pkg_dosrc src/java/*
}
