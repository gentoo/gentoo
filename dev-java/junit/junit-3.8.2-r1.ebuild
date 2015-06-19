# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/junit/junit-3.8.2-r1.ebuild,v 1.12 2013/02/05 05:50:17 zerochaos Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_P=${P/-/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Simple framework to write repeatable tests"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
HOMEPAGE="http://www.junit.org/"
LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}
	cd "${S}"

	unzip src.jar || die
	rm -v *.jar || die
	rm -rf javadoc ${PN}${PV} || die
	cp "${FILESDIR}/${P}-build.xml" build.xml || die
}

EANT_BUILD_TARGET="dist"

src_install() {
	use source && java-pkg_dosrc ${PN}
	cd ${MY_P}
	java-pkg_dojar ${PN}.jar
	dohtml README.html cpl-v10.html || die
	if use doc; then
		dohtml -r doc || die
		java-pkg_dojavadoc javadoc
	fi
}
