# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A small Java library with one purpose: To instantiate a new object of a class"
HOMEPAGE="https://objenesis.googlecode.com/"
SRC_URI="https://${PN}.googlecode.com/files/${P}-bin.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 x86"
IUSE=""

BDEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.8"
DEPEND=">=virtual/jdk-1.8"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="src"

src_unpack() {
	unpack ${A}
	unzip "${S}"/${P}-sources.jar -d "${S}"/src || die
}
