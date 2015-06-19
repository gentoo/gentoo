# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jnr-x86asm/jnr-x86asm-1.0.1.ebuild,v 1.4 2014/08/10 20:19:04 slyfox Exp $

EAPI="4"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A pure-java port of asmjit"
HOMEPAGE="http://github.com/jnr"
SRC_URI="http://github.com/jnr/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1.0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

src_unpack() {
	unpack ${A}
	mv jnr-jnr-x86asm-* ${P} || die
}

java_prepare() {
	cp "${FILESDIR}"/${PN}_maven-build.xml build.xml || die
}

JAVA_ANT_ENCODING="UTF-8"

EANT_EXTRA_ARGS="-Dmaven.build.finalName=${PN}"

src_install() {
	java-pkg_newjar target/${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
