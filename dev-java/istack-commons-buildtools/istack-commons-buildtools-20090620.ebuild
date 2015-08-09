# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="istack-commons - buildtools"
HOMEPAGE="https://istack-commons.dev.java.net/"
PROJ_PN="istack-commons"
PROJ_P="${PROJ_PN}-${PV}"
SUB_PN="buildtools"
SRC_FILE="${PROJ_P}-src.tar.bz2"
SRC_URI="mirror://gentoo/${SRC_FILE}"

LICENSE="CDDL"
SLOT="1.1"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${PROJ_P}"

# Helper to generate the tarball :-)
# ( PN=istack-commons-runtime ; PV=20090620 ; P="${PN}-${PV}" ; . ${P}.ebuild  ; src_tarball )
src_tarball() {
	CVSROOT=':pserver:guest@cvs.dev.java.net:/cvs'
	PROJ_PN='istack-commons'
	cvs -d "${CVSROOT}" \
		export -D $PV -d "${PROJ_P}" \
		"${PROJ_PN}/${PROJ_PN}" && \
	tar cvjf "${SRC_FILE}" \
		--exclude '*.zip' \
		--exclude '*.jar' \
		"${PROJ_P}" \
		&& \
	echo "New tarball located at ${SRC_FILE}"
}

java_prepare() {
	epatch "${FILESDIR}/${PROJ_PN}-20090620-less-maven.patch"
	java-ant_bsfix_one "${S}/build-common.xml"
	libdir="${S}/${SUB_PN}/lib"
	mkdir -p "${libdir}" || die
	java-pkg_jar-from --into "${libdir}" ant-core
	java-pkg_jar-from --into "${libdir}" codemodel-2
	java-pkg_jar-from --into "${libdir}" istack-commons-runtime-1.1
}

EANT_BUILD_XML="${SUB_PN}/build.xml"

src_install() {
	java-pkg_dojar ${SUB_PN}/build/${PN}.jar
	use source && java-pkg_dosrc ${SUB_PN}/src/*
}
