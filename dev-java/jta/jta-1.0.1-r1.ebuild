# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jta/jta-1.0.1-r1.ebuild,v 1.9 2011/01/21 01:47:16 fordfrog Exp $

inherit java-pkg-2

At="jta-1_0_1B-classes.zip"
DESCRIPTION="The Java Transaction API"
HOMEPAGE="http://www.oracle.com/technetwork/java/javaee/tech/jta-138684.html"
SRC_URI="${At}"
LICENSE="sun-bcla-jta"
SLOT=0
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""
DEPEND=">=app-arch/unzip-5.50-r1
	>=virtual/jdk-1.3"
RDEPEND=">=virtual/jre-1.3"
RESTRICT="fetch"

S=${WORKDIR}

pkg_nofetch() {
	einfo
	einfo " Due to license restrictions, we cannot fetch the"
	einfo " distributables automagically."
	einfo
	einfo " 1. Visit ${HOMEPAGE}"
	einfo " 2. Select 'Java Transaction API Specification 1.0.1B Class Files 1.0.1B'"
	einfo " 3. Download ${At}"
	einfo " 4. Move file to ${DISTDIR}"
	einfo " 5. Restart the emerge process"
	einfo
}

src_unpack() {
	unzip -qq "${DISTDIR}"/${At} || die "failed too unpack"
}

src_compile() {
	jar cvf jta.jar javax/ || die "failed to create jar"
}

src_install() {
	java-pkg_dojar jta.jar
}
