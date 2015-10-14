# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Implementation of the HTML5 parsing algorithm in Java"
HOMEPAGE="http://about.validator.nu/htmlparser/"
SRC_URI="http://about.validator.nu/${PN}/${P}.zip"

LICENSE="W3C"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="
	dev-java/icu4j:52
	dev-java/jchardet:0
	dev-java/xom:0"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
	app-arch/unzip"

java_prepare() {
	java-pkg_clean
	mkdir -p build lib || die
	cp "${FILESDIR}/build.xml" build.xml || die "cp failed"
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="icu4j-52,xom,jchardet"

src_install() {
	java-pkg_dojar "${PN}.jar"
	use source && java-pkg_dosrc src/*
	use doc && java-pkg_dojavadoc docs
}
