# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN%-qual}"
MY_P="${MY_PN}-${PV}"
JAVA_PKG_IUSE="doc source"
JAVA_TESTING_FRAMEWORKS="junit"
MAVEN_ID="org.checkerframework:checker-qual:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Annotations for type-checking by the Checker Framework"
HOMEPAGE="https://checkerframework.org/"
SRC_URI="https://codeload.github.com/typetools/${MY_PN}/tar.gz/refs/tags/${MY_P} -> ${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${MY_PN}-${MY_P}/checker-qual"

JAVA_SRC_DIR="src/main/java/org/checkerframework/"
