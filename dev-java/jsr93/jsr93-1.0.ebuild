# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java API for XML Registries (JAXR) - API"
HOMEPAGE="http://download.oracle.com/otndocs/jcp/jaxr-1.0-fr-oth-JSpec/"
SRC_URI="jaxr-1_0-fr-spec.zip"

LICENSE="sun-jsr93"
RESTRICT="fetch"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""

COMMON_DEP="dev-java/sun-jaf"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}"

pkg_nofetch() {

	einfo "Please go to"
	einfo " ${HOMEPAGE}"
	einfo "and download file:"
	einfo ' "Java API for XML Registries Specification 1.0"'
	einfo "Place the file ${SRC_URI} in:"
	einfo " ${DISTDIR}"

}

src_unpack() {

	unpack ${A}

	cd "${WORKDIR}"
	mkdir src || die
	unzip -qq jaxr-apisrc.jar -d src || die "unzip failed"
	rm -v *.jar || die
	mkdir lib || die

	cd lib
	java-pkg_jar-from sun-jaf

	cp "${FILESDIR}/build.xml-${PV}" "${S}/build.xml" || die

}

src_install() {

	java-pkg_dojar "jsr93-api.jar"

	use source && java-pkg_dosrc src/*

}
