# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom diffutils-1.3.0.pom.xml --download-uri https://repo1.maven.org/maven2/com/googlecode/java-diff-utils/diffutils/1.3.0/diffutils-1.3.0-sources.jar --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild java-diff-utils-1.3.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.googlecode.java-diff-utils:diffutils:1.3.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library for computing diffs, applying patches, generationg side-by-side view"
HOMEPAGE="http://code.google.com/p/java-diff-utils/"
SRC_URI="https://repo1.maven.org/maven2/com/googlecode/${PN}/diffutils/${PV}/diffutils-${PV}-sources.jar -> ${P}-sources.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"
