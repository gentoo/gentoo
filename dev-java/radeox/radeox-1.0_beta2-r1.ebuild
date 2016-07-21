# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Radeox Wiki render engine"
HOMEPAGE="http://www.radeox.org"
MY_PV="${PV/_beta/-BETA-}"
MY_P="${PN}-${MY_PV}"
SRC_URI="ftp://snipsnap.org/radeox/${MY_P}-src.tgz"
LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="amd64 x86"
IUSE=""
RDEPEND=">=virtual/jre-1.4
	=dev-java/commons-logging-1*"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# TOOD:
	# these would get bundled to the final jar
	# we should try to run the tests though
	rm -rf  src/org/radeox/example/ \
		src/test/ src/org/radeox/test/

	rm -v lib/*.jar || die
	rm -v src/org/radeox/filter/*.class || die
	rm -v src/org/radeox/*/*/*.class || die
	cd lib
	java-pkg_jar-from commons-logging
}

EANT_BUILD_TARGET="jar jar-api"

src_install() {
	dodoc Changes.txt README Radeox.version || die
	use doc && java-pkg_dojavadoc docs/api
	use source && java-pkg_dosrc src/org
	java-pkg_dojar lib/{radeox,radeox-api}.jar
}
