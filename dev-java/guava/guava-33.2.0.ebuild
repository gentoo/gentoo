# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.guava:guava:${PV}-jre"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A collection of Google's core Java libraries"
HOMEPAGE="https://github.com/google/guava"
SRC_URI="https://github.com/google/guava/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

CP_DEPEND="
	>=dev-java/error-prone-annotations-2.27.1:0
	dev-java/j2objc-annotations:0
	dev-java/jsr305:0
"

DEPEND="${CP_DEPEND}
	dev-java/checker-framework-qual:0
	>=virtual/jdk-1.8:*"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="com.google.common"
JAVA_CLASSPATH_EXTRA="checker-framework-qual"
JAVA_GENTOO_CLASSPATH_EXTRA=":futures/failureaccess/src"
JAVA_SRC_DIR="guava/src"
