# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jnr-unixsocket/jnr-unixsocket-0.6.ebuild,v 1.2 2015/06/17 17:14:09 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Unix sockets for Java"
SRC_URI="http://github.com/jnr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/jnr/jnr-unixsocket"

SLOT="0"
KEYWORDS="amd64 x86"
LICENSE="Apache-2.0"

CDEPEND="dev-java/jnr-constants:0
	dev-java/jnr-enxio:0
	dev-java/jnr-posix:3.0
	dev-java/jnr-ffi:0.7"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.6"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="jnr-constants,jnr-enxio,jnr-ffi-0.7,jnr-posix-3.0"

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	use source && java-pkg_dosrc src/main/java/jnr
	use examples && java-pkg_doexamples src/main/java/jnr/unixsocket/example
	use doc && java-pkg_dojavadoc target/site/apidocs
}
