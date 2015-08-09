# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=1

inherit java-pkg-2

DESCRIPTION="Java Dependency checker"
HOMEPAGE="http://www.gentoo.org/proj/en/java"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

COMMON_DEP="
	dev-java/commons-cli:1
	dev-java/asm:3"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

S="${WORKDIR}"

src_unpack() {
	cp "${FILESDIR}/Main-${PV}.java" Main.java || die
}
src_compile() {
	ejavac -cp $(java-pkg_getjars asm-3,commons-cli-1) -encoding UTF-8 -d . Main.java
	jar cf ${PN}.jar javadepchecker/*.class || die "jar failed"
}

src_install() {
	java-pkg_dojar ${PN}.jar
	java-pkg_dolauncher ${PN} --main javadepchecker.Main
}
