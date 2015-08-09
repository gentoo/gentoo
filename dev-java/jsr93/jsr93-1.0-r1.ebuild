# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5

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

CDEPEND="dev-java/sun-jaf:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

S="${WORKDIR}"

JAVA_ANT_ENCODING="ISO-8859-1"

pkg_nofetch() {

	einfo "Please go to"
	einfo " ${HOMEPAGE}"
	einfo "and download file:"
	einfo ' "Java API for XML Registries Specification 1.0"'
	einfo "Place the file ${SRC_URI} in:"
	einfo " ${DISTDIR}"

}

java_prepare() {
	cd "${WORKDIR}" || die "can't cd in ${WORKDIR}"
	mkdir src || die
	unzip -qq jaxr-apisrc.jar -d src || die "unzip failed"
	rm -v *.jar || die
	mkdir lib || die
	cd lib || die "can't cd in ${WORKDIR}/lib"

	java-pkg_jar-from sun-jaf

	cp "${FILESDIR}/build.xml-${PV}" "${S}/build.xml" || die
}

src_install() {
	java-pkg_dojar "jsr93-api.jar"

	use source && java-pkg_dosrc src/*
}
