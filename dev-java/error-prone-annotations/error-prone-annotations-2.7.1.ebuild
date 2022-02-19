# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://codeload.github.com/google/error-prone/tar.gz/v2.7.1 --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild error-prone-annotations-2.7.1-r1.ebuild

EAPI=7

MY_PN="${PN%-annotations}"
MY_P="${MY_PN}-${PV}"
JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.errorprone:error_prone_annotations:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java annotations for the Error Prone static analysis tool"
HOMEPAGE="http://errorprone.info"
SRC_URI="https://codeload.github.com/google/${MY_PN}/tar.gz/v${PV} -> ${MY_P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${MY_P}/annotations"
JAVA_SRC_DIR="src/main/java"
