# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

MY_PN=apache-${PN%%-bin}
MY_PV=${PV/_alpha/-alpha-}
MY_P="${MY_PN}-${MY_PV}"
MY_MV="${PV%%.*}"

DESCRIPTION="Project Management and Comprehension Tool for Java"
SRC_URI="mirror://apache/maven/maven-${MY_MV}/${PV}/binaries/${MY_P}-bin.tar.gz"
HOMEPAGE="https://maven.apache.org/"

LICENSE="Apache-2.0"
SLOT="3.6"
KEYWORDS="amd64 x86"

DEPEND="
	>=virtual/jdk-1.8
	app-eselect/eselect-java"

RDEPEND="
	>=virtual/jre-1.8"

S="${WORKDIR}/${MY_P}"

MAVEN="${PN}-${SLOT}"
MAVEN_SHARE="/usr/share/${MAVEN}"

# TODO:
# We should use jars from packages, instead of what is bundled.
src_install() {
	dodir "${MAVEN_SHARE}"

	cp -Rp bin boot conf lib "${ED}/${MAVEN_SHARE}" || die "failed to copy"

	java-pkg_regjar "${ED}/${MAVEN_SHARE}"/boot/*.jar
	java-pkg_regjar "${ED}/${MAVEN_SHARE}"/lib/*.jar

	dodoc NOTICE README.txt

	dodir /usr/bin
	dosym "${MAVEN_SHARE}/bin/mvn" /usr/bin/mvn-${SLOT}

	# See bug #342901.
	echo "CONFIG_PROTECT=\"${MAVEN_SHARE}/conf\"" > "${T}/25${MAVEN}" || die
	doenvd "${T}/25${MAVEN}"
}

pkg_postinst() {
	eselect maven update mvn-${SLOT}
}

pkg_postrm() {
	eselect maven update
}
