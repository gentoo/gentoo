# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/aspectwerkz/aspectwerkz-2.0_rc2-r3.ebuild,v 1.6 2014/08/10 20:08:15 slyfox Exp $

EAPI=1
# no rewriting required since we patch build.xml to contain target/source
JAVA_PKG_BSFIX="off"
JAVA_PKG_IUSE="source"

inherit java-pkg-2 eutils java-ant-2

DESCRIPTION="AspectWerkz is a dynamic, lightweight and high-performant AOP/AOSD framework for Java"
SRC_URI="http://dist.codehaus.org/${PN}/distributions/${P/_rc/.RC}.zip"
HOMEPAGE="http://aspectwerkz.codehaus.org"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="amd64 ppc ~ppc64 x86"
RDEPEND=">=virtual/jre-1.5
	dev-java/asm:1.5
	dev-java/concurrent-util:0
	dev-java/dom4j:1
	dev-java/jrexx:0
	dev-java/junit:0
	dev-java/trove:0
	dev-java/qdox:1.6"
DEPEND=">=virtual/jdk-1.5
	${RDEPEND}
	app-arch/unzip"
IUSE=""

S=${WORKDIR}/aw_2_0_2

# These fail
RESTRICT="test"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-jdk15.patch

	find . -name '*.jar' -exec rm -v {} \; || die
	find . -name '*.class' -exec rm -v {} \; || die
	cd "${S}"/lib
	java-pkg_jar-from asm-1.5
	java-pkg_jar-from concurrent-util
	java-pkg_jar-from dom4j-1
	java-pkg_jar-from jrexx
	java-pkg_jar-from junit
	java-pkg_jar-from trove
	java-pkg_jar-from qdox-1.6
}

src_compile() {
	eant dist || die "eant failed"
}

src_install() {
	java-pkg_dojar lib/${PN}*.jar

	use source && java-pkg_dosrc src/*
}
