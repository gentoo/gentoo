# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.checkerframework:checker-qual:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Annotations for type-checking by the Checker Framework"
HOMEPAGE="https://checkerframework.org/"
SRC_URI="https://github.com/typetools/checker-framework/archive/checker-framework-${PV}.tar.gz"
S="${WORKDIR}/checker-framework-checker-framework-${PV}/checker-qual"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="org.checkerframework.checker.qual"
JAVA_SRC_DIR="src/main/java/org/checkerframework/"
