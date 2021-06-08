# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.ow2.asm:asm-tree:9.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Bytecode manipulation framework for Java (Tree API)"
HOMEPAGE="http://asm.ow2.org"
MY_P="ASM_${PV//./_}"
SRC_URI="https://gitlab.ow2.org/asm/asm/-/archive/${MY_P}/asm-${MY_P}.tar.gz"
LICENSE="BSD"
SLOT=`ver_cut 1`
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~x64-macos"
RESTRICT="test"

CDEPEND="dev-java/asm:${SLOT}"
DEPEND=">=virtual/jdk-1.8
${CDEPEND}
"
RDEPEND=">=virtual/jre-1.8
${CDEPEND}
"

JAVA_GENTOO_CLASSPATH="asm-${SLOT}"
JAVA_SRC_DIR="asm-${MY_P}/${PN}/src/main/java"
