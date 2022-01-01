# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JTA_ZIP="jta-1_1-classes.zip"

inherit java-pkg-2

DESCRIPTION="The Java Transaction API"
HOMEPAGE="http://www.oracle.com/technetwork/java/javaee/jta/index.html"
SRC_URI="${JTA_ZIP}"
LICENSE="sun-bcla-jta"
SLOT=0
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux"

DEPEND=" >=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

RESTRICT="fetch"

S="${WORKDIR}"

pkg_nofetch() {
	einfo
	einfo " Due to license restrictions, we cannot fetch the"
	einfo " distributables automagically."
	einfo
	einfo " 1. Visit ${HOMEPAGE}"
	einfo " 2. Select 'Java Transaction API Specification 1.1 Maintenance Release'"
	einfo " 3. Download ${JTA_ZIP}"
	einfo " 4. Move file to your DISTDIR directory"
	einfo " 5. Restart the emerge process"
	einfo
}

src_unpack() {
	unzip -qq "${DISTDIR}"/${JTA_ZIP} || die "failed to unpack"
}

src_compile() {
	jar cvf jta.jar javax/ || die "failed to create jar"
}

src_install() {
	java-pkg_dojar jta.jar
}
