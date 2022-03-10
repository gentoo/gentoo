# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Resin Servlet API 3.0/JSP API 2.1 implementation"
HOMEPAGE="https://caucho.com"
SRC_URI="https://caucho.com/download/resin-${PV}-src.tar.gz"

LICENSE="GPL-2"
SLOT="3.1"
KEYWORDS="amd64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/resin-${PV}"

src_prepare() {
	default
	cd "${S}"
	rm -f modules/ext/*.jar project-jars/*.jar webapp-jars/*.jar
	java-ant_bsfix_files build-common.xml || die
}

EANT_BUILD_TARGET="servlet16"
EANT_DOC_TARGET=""

src_install() {
	java-pkg_newjar "modules/servlet16/dist/servlet-16.jar"
	use source && java-pkg_dosrc "${S}"/modules/servlet16/src/*

	dosym "${PN}.jar" "/usr/share/${PN}-${SLOT}/lib/servlet-api.jar"
	java-pkg_regjar "${D}/usr/share/${PN}-${SLOT}/lib/servlet-api.jar"
	dosym "${PN}.jar" "/usr/share/${PN}-${SLOT}/lib/jsp-api.jar"
	java-pkg_regjar "${D}/usr/share/${PN}-${SLOT}/lib/jsp-api.jar"
}
