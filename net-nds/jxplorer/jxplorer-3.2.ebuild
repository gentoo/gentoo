# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/jxplorer/jxplorer-3.2.ebuild,v 1.7 2014/08/10 20:53:09 slyfox Exp $

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A fully functional ldap browser written in java"
HOMEPAGE="http://jxplorer.org/"
SRC_URI="mirror://sourceforge/${PN}/JXv${PV}src.tar.bz2
	mirror://sourceforge/${PN}/JXv${PV}deploy.tar.bz2"
LICENSE="CAOSL"
SLOT="0"
KEYWORDS="amd64 ppc x86"
RDEPEND=">=virtual/jre-1.4
	>=dev-java/javahelp-2.0.02_p46
	>=dev-java/log4j-1.2.8
	=dev-java/junit-3.8*"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	cp "${FILESDIR}/build.xml" ./build.xml || die

	# Contains stuff for javahelp
	mkdir dist
	cp jars/help.jar dist || die

	rm -v jars/*.jar || die
	mkdir lib/ && cd lib/
	java-pkg_jar-from javahelp
	java-pkg_jar-from log4j
	java-pkg_jar-from junit
}

EANT_DOC_TARGET="docs"
EANT_FILTER_COMPILER="jikes"

src_install() {
	java-pkg_dojar dist/${PN}.jar dist/help.jar

	dodir /usr/share/${PN}
	for i in "icons images htmldocs language templates security connections.txt log4j.xml"
	do
		cp -r ${i} "${D}/usr/share/${PN}" || die
	done

	dodoc RELEASE.TXT || die

	# By default the config dir is ${HOME}/jxplorer
	java-pkg_dolauncher ${PN} \
		--main com.ca.directory.jxplorer.JXplorer \
		--pwd '"${HOME}/.jxplorer"' \
		--pkg_args console \
		-pre "${FILESDIR}/${PN}-pre-r1"

	use source && java-pkg_dosrc src/com
	use doc && java-pkg_dojavadoc docs
}
