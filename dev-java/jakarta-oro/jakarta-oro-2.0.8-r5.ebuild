# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source examples"
MAVEN_ID="oro:oro:2.0.8"

inherit java-pkg-2 java-pkg-simple

MY_J=${PN%%-*}
MY_O=${PN##*-}

DESCRIPTION="A set of text-processing Java classes"
HOMEPAGE="https://jakarta.apache.org/oro/"
SRC_URI="https://archive.apache.org/dist/${MY_J}/${MY_O}/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="2.0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src"

src_prepare() {
	default
	java-pkg_clean
	mv src/java/examples examples || die
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples examples
}
