# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java library for parsing command line options"
HOMEPAGE="https://jopt-simple.github.io/jopt-simple/"
SRC_URI="https://github.com/jopt-simple/jopt-simple/archive/jopt-simple-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"

KEYWORDS="amd64 ~arm arm64 ppc64 x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

src_install() {
	einstalldocs
	java-pkg-simple_src_install
}
