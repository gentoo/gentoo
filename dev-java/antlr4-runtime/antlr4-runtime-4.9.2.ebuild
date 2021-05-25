# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/antlr/antlr4/archive/refs/tags/4.9.2.tar.gz --slot 4 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild antlr4-runtime-4.9.2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.antlr:antlr4-runtime:4.9.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The ANTLR 4 Runtime"
HOMEPAGE="https://www.antlr.org/"
SRC_URI="https://github.com/antlr/antlr4/archive/refs/tags/${PV}.tar.gz -> antlr4-${PV}.tar.gz"

LICENSE="BSD"
SLOT="4"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/antlr4-${PV}/runtime/Java"

JAVA_SRC_DIR="src"

src_prepare() {
	default
	java-pkg_clean
}
