# Copyright 2016-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Dependency checker"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Java"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEP="
	dev-java/commons-cli:1
	dev-java/asm:4"
RDEPEND=">=virtual/jre-1.8:*
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.8:*
	${COMMON_DEP}"

JAVA_GENTOO_CLASSPATH="asm-4,commons-cli-1"

src_unpack() {
	cp "${FILESDIR}/Main-${PV}.java" Main.java || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher ${PN} --main javadepchecker.Main
}
