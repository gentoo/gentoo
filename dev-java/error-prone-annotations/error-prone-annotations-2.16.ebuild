# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/google/error-prone/archive/v2.16.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild error-prone-annotations-2.16.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.errorprone:error_prone_annotations:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java annotations for the Error Prone static analysis tool"
HOMEPAGE="https://errorprone.info"
SRC_URI="https://github.com/google/error-prone/archive/v${PV}.tar.gz -> error-prone-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/error-prone-${PV}/annotations"

JAVA_AUTOMATIC_MODULE_NAME="com.google.errorprone.annotations"
JAVA_SRC_DIR="src/main/java"
