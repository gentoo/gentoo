# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="gnu.getopt:java-getopt:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java command line option parser"
HOMEPAGE="https://www.urbanophile.com/arenn/hacking/download.html"
SRC_URI="https://www.urbanophile.com/arenn/hacking/getopt/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="amd64 ~arm64 ppc64 ~x64-macos ~x64-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( gnu/getopt/{COPYING.LIB,ChangeLog,LANGUAGES,README} )

JAVA_RESOURCE_DIRS="resources"
JAVA_SRC_DIR="gnu/getopt"

src_prepare() {
	java-pkg-2_src_prepare
		mkdir resources || die
		find gnu/getopt -type f -name '*.properties' \
		| xargs cp --parent -t resources || die
}
