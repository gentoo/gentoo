# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/httpcomponents-core/httpcomponents-core-4.2.4.ebuild,v 1.2 2014/08/10 20:14:49 slyfox Exp $

EAPI="5"

JAVA_PKG_IUSE="source examples"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A low level toolset of Java components focused on HTTP and associated protocols"
HOMEPAGE="http://hc.apache.org/index.html"
SRC_URI="mirror://apache/${PN/-//http}/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

EANT_BUILD_TARGET="package"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die

	for x in "${FILESDIR}"/${P}-httpcore*; do
		d=$(basename ${x})
		d=${d/${P}-}
		cp "${x}" ${d/-build.xml}/build.xml || die
	done
}

src_install() {
	for mod in httpcore httpcore-nio ; do
		java-pkg_newjar ${mod}/target/${mod}-${PV}.jar ${mod}.jar
	done

	use source && java-pkg_dosrc httpcore{,-nio}/src/main/java
	use examples && java-pkg_doexamples httpcore{,-nio}/src/examples

	dodoc {README,RELEASE_NOTES,NOTICE}.txt
}
