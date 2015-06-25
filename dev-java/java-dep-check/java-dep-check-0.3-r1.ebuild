# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-dep-check/java-dep-check-0.3-r1.ebuild,v 1.1 2015/06/25 22:30:37 chewi Exp $

EAPI=5

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Dependency checker"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Java"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEP="
	dev-java/commons-cli:1
	dev-java/asm:3"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

JAVA_GENTOO_CLASSPATH="asm-3,commons-cli-1"

src_unpack() {
	cp "${FILESDIR}/Main-${PV}.java" Main.java || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher ${PN} --main javadepchecker.Main
}
