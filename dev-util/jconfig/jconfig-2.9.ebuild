# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="jConfig is an extremely helpful utility, providing a simple API for the management of properties"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-v${PV}.tar.gz"
HOMEPAGE="http://www.jconfig.org/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="java-virtuals/jmx"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

S="${WORKDIR}/${PN/c/C}"

java_prepare() {
	cd "${S}"

	rm -v dist/*.jar || die
	rm -v lib/*.jar || die

	java-pkg_jar-from --into lib jmx
}

JAVA_ANT_ENCODING="ISO-8859-1"

src_install() {
	java-pkg_dojar dist/jconfig.jar

	dodoc README || die

	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/*

}
