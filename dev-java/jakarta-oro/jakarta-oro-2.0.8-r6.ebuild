# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source examples"
MAVEN_ID="oro:oro:2.0.8"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A set of text-processing Java classes"
HOMEPAGE="https://jakarta.apache.org/oro/"
SRC_URI="https://archive.apache.org/dist/jakarta/oro/source/jakarta-oro-${PV}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-1.1"
SLOT="2.0"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos ~x64-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean
	mv src/java/examples examples || die
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples examples
}
