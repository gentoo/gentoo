# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java code generator module of JavaCC"
HOMEPAGE="https://javacc.github.io/javacc-8/"
SRC_URI="https://github.com/javacc/javacc-8-java/archive/java-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/javacc-8-java-java-${PV}"

LICENSE="BSD-2"
SLOT="8"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	dev-java/javacc:8
	>=virtual/jdk-1.8:*
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="javacc-8"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
