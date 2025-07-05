# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.jspecify:jspecify:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JSpecify annotations"
HOMEPAGE="https://jspecify.dev/"
SRC_URI="https://github.com/jspecify/jspecify/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_INTERMEDIATE_JAR_NAME="org.jspecify"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/java9/java" )

JAVA_SRC_DIR="src/main/java"
