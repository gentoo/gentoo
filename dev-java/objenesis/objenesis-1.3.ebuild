# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A small Java library with one purpose: To instantiate a new object of a class"
HOMEPAGE="http://${PN}.googlecode.com/"
SRC_URI="http://${PN}.googlecode.com/files/${P}-bin.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ppc ppc64"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="src"

src_unpack() {
	unpack ${A}
	unzip "${S}"/${P}-sources.jar -d "${S}"/src || die
}
