# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/maven-bin/maven-bin-2.2.1.ebuild,v 1.8 2015/03/31 18:58:00 ulm Exp $

inherit java-pkg-2

MY_PN=apache-${PN%%-bin}
MY_P="${MY_PN}-${PV}"
MY_MV="${PV%%.*}"

DESCRIPTION="Project Management and Comprehension Tool for Java"
SRC_URI="mirror://apache/maven/maven-${MY_MV}/${PV}/binaries/${MY_P}-bin.tar.bz2"
HOMEPAGE="http://maven.apache.org/"
LICENSE="Apache-2.0"
SLOT="2.2"
KEYWORDS="amd64 ppc x86"

RDEPEND=">=virtual/jdk-1.5
	app-eselect/eselect-maven"

IUSE=""

S="${WORKDIR}/${MY_P}"

MAVEN=${PN}-${SLOT}
MAVEN_SHARE="/usr/share/${MAVEN}"

src_unpack() {
	unpack ${A}

	rm -v "${S}"/bin/*.bat || die
}

# TODO we should use jars from packages, instead of what is bundled
src_install() {
	dodir "${MAVEN_SHARE}"
	cp -Rp bin boot conf lib "${D}/${MAVEN_SHARE}" || die "failed to copy"

	java-pkg_regjar "${D}/${MAVEN_SHARE}"/lib/*.jar

	dodoc NOTICE.txt README.txt || die

	dodir /usr/bin
	dosym "${MAVEN_SHARE}/bin/mvn" /usr/bin/mvn-${SLOT}

	# bug #342901
	echo "CONFIG_PROTECT=\"${MAVEN_SHARE}/conf\"" > "${T}/25${MAVEN}" || die
	doenvd "${T}/25${MAVEN}"
}
