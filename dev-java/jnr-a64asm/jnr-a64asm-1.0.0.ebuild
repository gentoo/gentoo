# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jnr/jnr-a64asm/archive/refs/tags/jnr-a64asm-1.0.0.tar.gz --slot 2 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild jnr-a64asm-1.0.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.github.jnr:jnr-a64asm:1.0.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A pure-java A64 assembler"
HOMEPAGE="http://nexus.sonatype.org/oss-repository-hosting.html/jnr-a64asm"
SRC_URI="https://github.com/jnr/${PN}/archive/refs/tags/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR="src/main/java"
