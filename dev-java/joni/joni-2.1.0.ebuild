# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="source"

inherit base java-pkg-2 java-ant-2

DESCRIPTION="Java port of the Oniguruma regular expression engine"
HOMEPAGE="http://jruby.codehaus.org/"
SRC_URI="https://github.com/jruby/${PN}/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="2.1"
KEYWORDS="amd64 ~ppc64 x86 ~amd64-linux ~x86-linux ~x86-solaris"

CDEPEND="dev-java/asm:3
	dev-java/jcodings:1"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.5"

S="${WORKDIR}/${PN}-${PN}-${PV}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_BUILD_TARGET="build"
EANT_GENTOO_CLASSPATH="asm-3 jcodings-1"

src_install() {
	java-pkg_dojar target/${PN}.jar

	use source && java-pkg_dosrc src/*
}
