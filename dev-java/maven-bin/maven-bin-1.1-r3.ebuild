# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/maven-bin/maven-bin-1.1-r3.ebuild,v 1.6 2015/03/31 18:58:00 ulm Exp $

EAPI="4"

MY_PN=${PN/-bin}
MY_PV=${PV/_/-}
MY_P=${MY_PN}-${MY_PV}
MY_MV="${PV%%.*}"

DESCRIPTION="Project Management and Comprehension Tool for Java"
SRC_URI="mirror://apache/maven/maven-${MY_MV}/${PV}/binaries/${MY_P}.tar.gz"
HOMEPAGE="http://maven.apache.org/"

LICENSE="Apache-2.0"
SLOT="1.1"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="|| ( app-eselect/eselect-java app-eselect/eselect-maven )"
RDEPEND=">=virtual/jdk-1.5
	${DEPEND}"

S="${WORKDIR}/${MY_P}"
MAVEN=${PN}-${SLOT}
MAVEN_HOME="/usr/share/${MAVEN}"
MAVEN_BIN="${MAVEN_HOME}/bin"

src_install() {
	dodir ${MAVEN_HOME}
	insinto ${MAVEN_HOME}
	doins -r bin lib *.xsd plugins

	dodir ${MAVEN_BIN}
	exeinto ${MAVEN_BIN}
	doexe "${FILESDIR}/${MY_PN}"

	dodir /usr/bin
	dosym ${MAVEN_BIN}/${MY_PN} /usr/bin/mvn-${SLOT}
}

pkg_postinst() {
	eselect maven update mvn-${SLOT}
}

pkg_postrm() {
	eselect maven update
}
