# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="istack-commons - tools"
HOMEPAGE="https://istack-commons.dev.java.net/"
PROJ_PN="istack-commons"
PROJ_P="${PROJ_PN}-${PV}"
SRC_FILE="${PROJ_P}-src.tar.bz2"
SRC_URI="mirror://gentoo/${SRC_FILE}"

LICENSE="CDDL"
SLOT="1.1"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.5
	dev-java/ant-core"
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
	java-ant_bsfix_one "${S}/build-common.xml"
	cd "${S}/tools"
	mkdir -p lib || die
	ln -s $(java-config --tools) lib || die
	java-pkg_jar-from --build-only --into "${S}"/tools/lib ant-core ant.jar
}

EANT_BUILD_XML="tools/build.xml"

src_install() {

	java-pkg_dojar tools/build/istack-commons-tools.jar

	use source && java-pkg_dosrc tools/src/*

}
