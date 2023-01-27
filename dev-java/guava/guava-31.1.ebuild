# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/google/guava/archive/refs/tags/v31.1.tar.gz --slot 0 --keywords "amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild guava-31.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.guava:guava:${PV}-jre"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A collection of Google's core Java libraries"
HOMEPAGE="https://github.com/google/guava"
SRC_URI="https://github.com/google/guava/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# com.google.code.findbugs:jsr305:3.0.2 -> >=dev-java/jsr305-3.0.2:0
# com.google.errorprone:error_prone_annotations:2.11.0 -> >=dev-java/error-prone-annotations-2.16:0
# com.google.guava:failureaccess:1.0.1 -> >=dev-java/failureaccess-30.1.1:0
# com.google.guava:listenablefuture:9999.0-empty-to-avoid-conflict-with-guava -> !!!artifactId-not-found!!!
# com.google.j2objc:j2objc-annotations:1.3 -> >=dev-java/j2objc-annotations-2.8:0
# org.checkerframework:checker-qual:3.12.0 -> >=dev-java/checker-framework-qual-3.14.0:0

CP_DEPEND="
	>=dev-java/checker-framework-qual-3.14.0:0
	>=dev-java/error-prone-annotations-2.16:0
	>=dev-java/failureaccess-30.1.1:0
	>=dev-java/j2objc-annotations-2.8:0
	>=dev-java/jsr305-3.0.2:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/${P}"

JAVA_AUTOMATIC_MODULE_NAME="com.google.common"
JAVA_SRC_DIR="guava/src"
