# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
JAVA_PKG_IUSE="doc source test"
PROJ_PN="jsr311"
PROJ_PV="${PV}"
PROJ_P="${PROJ_PN}-${PROJ_PV}"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JAX-RS: Java API for RESTful Web Services"
HOMEPAGE="https://jsr311.dev.java.net/"
SRC_FILE="${P}-src.tar.bz2"
SRC_URI="mirror://gentoo/${SRC_FILE}"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=virtual/jdk-1.5
		test? ( dev-java/ant-junit:0 dev-java/junit:0 )"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${P}/${PN}"

# Helper to generate the tarball :-)
# ( PN=jsr311-api ; PV=1.1 ; P="${PN}-${PV}" ; . ${P}.ebuild  ; src_tarball )
src_tarball() {
	SVN_SRC_URI="${HOMEPAGE}/svn/${PROJ_PN}/tags/${P}"
	tarball="${P}"
	svn export \
		--username guest --password '' --non-interactive \
		${SVN_SRC_URI} ${tarball} \
		&& \
	tar cvjf ${SRC_FILE} ${tarball} \
		&& \
	echo "New tarball located at ${SRC_FILE}"
}

java_prepare() {
	for i in build.xml maven-build.xml manifest ; do
		cp -f "${FILESDIR}"/"${P}-${i}" "${i}" \
			|| die "Unable to find ${P}-${i}"
	done
}

src_install() {
	dodoc README.txt || die
	java-pkg_newjar target/${P}.jar ${PN}.jar
	use doc	&& java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/javax
}

src_test() {
	EANT_GENTOO_CLASSPATH="junit ant-core" \
	ANT_TASKS="ant-junit" \
	eant test
}
