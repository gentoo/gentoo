# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit java-pkg-2

MY_PN=apache-${PN%%-bin}
MY_P="${MY_PN}-${PV}"
MY_MV="${PV%%.*}"

DESCRIPTION="Project Management and Comprehension Tool for Java"
SRC_URI="mirror://apache/maven/maven-${MY_MV}/${PV}/binaries/${MY_P}-bin.tar.bz2"
HOMEPAGE="http://maven.apache.org/"

LICENSE="Apache-2.0"
SLOT="2.2"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-eselect/eselect-java"
RDEPEND=">=virtual/jdk-1.5
	${DEPEND}"

S="${WORKDIR}/${MY_P}"

MAVEN=${PN}-${SLOT}
MAVEN_SHARE="/usr/share/${MAVEN}"

java_prepare() {
	rm -v "${S}"/bin/*.bat || die
}

# TODO we should use jars from packages, instead of what is bundled
src_install() {
	dodir "${MAVEN_SHARE}"
	cp -Rp bin boot conf lib "${ED}/${MAVEN_SHARE}" || die "failed to copy"

	java-pkg_regjar "${ED}/${MAVEN_SHARE}"/lib/*.jar

	dodoc NOTICE.txt README.txt

	dodir /usr/bin
	dosym "${MAVEN_SHARE}/bin/mvn" /usr/bin/mvn-${SLOT}

	# bug #342901
	echo "CONFIG_PROTECT=\"${MAVEN_SHARE}/conf\"" > "${T}/25${MAVEN}" || die
	doenvd "${T}/25${MAVEN}"
}

pkg_postinst() {
	eselect maven update mvn-${SLOT}
}

pkg_postrm() {
	eselect maven update
}
