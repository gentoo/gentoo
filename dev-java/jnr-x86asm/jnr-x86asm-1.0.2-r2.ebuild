# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.github.jnr:jnr-x86asm:1.0.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A pure-java port of asmjit"
HOMEPAGE="https://github.com/jnr/jnr-x86asm"
SRC_URI="https://github.com/jnr/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.zip"

LICENSE="MIT"
SLOT="1.0"
KEYWORDS="amd64 ~arm64 ppc64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"
JAVA_ANT_ENCODING="UTF-8"
