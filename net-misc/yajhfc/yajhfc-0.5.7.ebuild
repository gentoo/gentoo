# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/yajhfc/yajhfc-0.5.7.ebuild,v 1.1 2015/03/22 09:09:50 ercpe Exp $

EAPI=5

inherit java-pkg-2 java-pkg-simple

MY_P="${PN}-${PV}"
MY_P="${MY_P/_/}"
MY_P="${MY_P/./_}"
MY_P="${MY_P/./_}"

DESCRIPTION="Yet another Java HylaFAX Plus Client"
HOMEPAGE="http://www.yajhfc.de/"
SRC_URI="http://download.yajhfc.de/releases/${MY_P}-src.zip"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="dev-java/gnu-hylafax:0
				dev-java/tablelayout:0"
RDEPEND="${COMMON_DEPEND} >=virtual/jre-1.6"
DEPEND="${COMMON_DEPEND} >=virtual/jdk-1.6 virtual/pkgconfig app-arch/unzip"

S="${WORKDIR}/${PN}"

JAVA_GENTOO_CLASSPATH="gnu-hylafax,tablelayout"
JAVA_SRC_DIR="src"

src_prepare() {
	rm build.xml || die
	rm -rv "${S}"/jna-src "${S}"/mac-src || die # contains win32/mac only code

	cp -r java1-src/* src || die
	cp -r java6-src/* src || die

	# this method is missing in the gnu-hylafax api despite they use the same upstream version
	sed -i -e 's/client.setCharacterEncoding.*//g' src/yajhfc/HylaClientManager.java || die
}

src_compile() {
	java-pkg-simple_src_compile
	pushd src || die
	find -type f -not -name "*.java" -not -name "*.class" | xargs jar uf "${S}"/${PN}.jar || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher ${PN} --jar ${PN}.jar --main yajhfc.Launcher
}
