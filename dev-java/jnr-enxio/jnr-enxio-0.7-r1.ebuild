# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java Native Runtime Enhanced X-platform I/O"
SRC_URI="https://github.com/jnr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/jnr/jnr-enxio"

SLOT="0"
KEYWORDS="amd64 x86"
LICENSE="Apache-2.0"

CDEPEND="dev-java/jnr-constants:0
	dev-java/jnr-ffi:2"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.7"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.7"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="jnr-constants,jnr-ffi-2"

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	use source && java-pkg_dosrc src/main/java/jnr
	use examples && java-pkg_doexamples src/main/java/jnr/enxio/example
	use doc && java-pkg_dojavadoc target/site/apidocs
}
