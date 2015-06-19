# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/htmlparser/htmlparser-1.4-r1.ebuild,v 1.1 2014/07/30 18:35:05 sera Exp $

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

COMMON_DEP="
	dev-java/icu4j:52
	dev-java/jchardet:0
	dev-java/xom:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	app-arch/unzip"

java_prepare() {
	find "${WORKDIR}" -name '*.jar' -delete || die
	mkdir -p build lib || die
	cp "${FILESDIR}/build.xml" build.xml || die "cp failed"
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_GENTOO_CLASSPATH="icu4j-52,xom,jchardet"

src_install() {
	java-pkg_dojar htmlparser.jar

	use source && java-pkg_dosrc src/*
	use doc && java-pkg_dojavadoc docs
}
