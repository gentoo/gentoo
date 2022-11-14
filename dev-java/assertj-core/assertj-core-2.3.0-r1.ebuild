# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.assertj:assertj-core:2.3.0"

inherit java-pkg-2 java-pkg-simple

GH_PN="assertj"
GH_TS="1668377184" # https://bugs.gentoo.org/881037 - bump this UNIX timestamp if the downloaded file changes checksum

DESCRIPTION="Java library that provides a fluent interface for writing assertions"
HOMEPAGE="https://joel-costigliola.github.io/assertj/"
SRC_URI="https://github.com/assertj/assertj/archive/refs/tags/assertj-core-${PV}.tar.gz
	-> ${P}.gh@${GH_TS}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"
SLOT="2"

CDEPEND="dev-java/cglib:3
	dev-java/junit:4"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

S="${WORKDIR}/${GH_PN}-${P}"
JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="cglib-3,junit-4"

src_install() {
	java-pkg-simple_src_install
	dodoc {CONTRIBUTING,README}.md
}
