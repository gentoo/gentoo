# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/jconfig/jconfig-2.8-r2.ebuild,v 1.3 2014/08/10 21:28:00 slyfox Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="jConfig is an extremely helpful utility, providing a simple API for the management of properties"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-v${PV}.tar.gz"
HOMEPAGE="http://www.jconfig.org/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

COMMON_DEP="dev-java/sun-jmx"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

S="${WORKDIR}/${PN/c/C}"

src_unpack() {

	unpack ${A}

	cd "${S}/dist/"
	rm -f *.jar

	cd "${S}/lib/"
	rm -f *.jar

	java-pkg_jar-from sun-jmx

}

src_install() {

	java-pkg_dojar dist/jconfig.jar

	dodoc README

	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/*

}
