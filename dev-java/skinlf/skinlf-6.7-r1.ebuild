# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/skinlf/skinlf-6.7-r1.ebuild,v 1.1 2014/03/08 17:23:12 tomwij Exp $

EAPI="5"

JAVA_PKG_IUSE="examples source"
WANT_ANT_TASKS="ant-nodeps"

inherit eutils java-pkg-2 java-ant-2

MY_P="${P}-20060722"

DESCRIPTION="Skin Look and Feel - Skinning Engine for the Swing toolkit"
HOMEPAGE="http://${PN}.l2fprod.com/"
SRC_URI="https://${PN}.dev.java.net/files/documents/66/37801/${MY_P}.zip"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/laf-plugin:0
	dev-java/xalan:0"

RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip:0
	${CDEPEND}"

java_prepare() {
	epatch "${FILESDIR}/${P}-image-utils-without-jimi.patch"

	cp "${FILESDIR}/${P}-build.xml" build.xml || die
	cp "${FILESDIR}/${P}-common.xml" common.xml || die

	cd lib || die

	# assert_built_jar_equals is your friend, upstream your enemy
	unzip ${PN}.jar '*.gif' '*.template' -d ../src || die
	rm -v *.jar || die

	java-pkg_jar-from xalan,laf-plugin
}

src_install() {
	java-pkg_dojar build/${PN}.jar

	# laf-plugin.jar is referenced in manifest's Class-Path
	# doesn't work without it due to class loader trickery
	# upstream solved this by absorbing laf-plugin in own jar...
	java-pkg_dojar lib/laf-plugin.jar

	use examples && java-pkg_doexamples src/examples
	use source && java-pkg_dosrc src/com src/*.java

	dodoc CHANGES README
}
