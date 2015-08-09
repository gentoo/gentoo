# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2

DESCRIPTION="An image to ASCII converter written in Java"
HOMEPAGE="http://www.roqe.org/jitac/"
SRC_URI="http://www.roqe.org/jitac/${P}.src.jar"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"

COMMON_DEP="
	dev-java/sun-jimi:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5"

S=${WORKDIR}

src_unpack() {
	jar -xvf "${DISTDIR}"/${A} || die "failed to unpack"
}

src_compile() {
	ejavac -classpath $(java-pkg_getjars sun-jimi):. $(find -name *.java)
	find . -name "*.class" -or -name "*.bdf" \
		-or -name "*.properties" -or -name "README" \
			| xargs jar -cf ${PN}.jar || die "failed to create jar"
}

src_install() {
	java-pkg_dojar ${PN}.jar
	java-pkg_dolauncher ${PN} --main org.roqe.jitac.Jitac

	dodoc org/roqe/jitac/README
	use doc && java-pkg_dohtml -r org/roqe/jitac/docs/*
}
