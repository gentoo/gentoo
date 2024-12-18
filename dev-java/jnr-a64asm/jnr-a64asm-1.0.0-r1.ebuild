# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.github.jnr:jnr-a64asm:1.0.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A pure-java A64 assembler"
HOMEPAGE="https://github.com/jnr/jnr-a64asm"
SRC_URI="https://github.com/jnr/${PN}/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 arm64 ppc64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"
