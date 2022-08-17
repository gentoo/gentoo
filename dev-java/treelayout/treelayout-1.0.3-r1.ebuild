# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/abego/treelayout/archive/v1.0.3.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild treelayout-1.0.3-r1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.abego.treelayout:org.abego.treelayout.core:1.0.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Efficient and customizable TreeLayout Algorithm in Java."
HOMEPAGE="https://github.com/abego/treelayout"
SRC_URI="https://github.com/abego/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

#	LICENSE="!!!equivalentPortageLicenseName-not-found!!!"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

DOCS=( ../README.md )

S="${WORKDIR}/${P}/org.abego.treelayout"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
