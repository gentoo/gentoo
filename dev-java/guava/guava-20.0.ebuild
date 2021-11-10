# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.guava:guava:20.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A collection of Google's core Java libraries"
HOMEPAGE="https://github.com/google/guava"
SRC_URI="https://github.com/google/guava/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="${PV%.*}"
KEYWORDS="amd64 arm64 ~ppc64 x86"

CP_DEPEND="
	dev-java/animal-sniffer-annotations:0
	dev-java/error-prone-annotations:0
	dev-java/jsr305:0
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.7"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.7
	dev-java/j2objc-annotations:0"

S="${WORKDIR}/${P}/${PN}"
JAVA_SRC_DIR="src"

src_configure() {
	JAVA_GENTOO_CLASSPATH_EXTRA=$(java-pkg_getjars --build-only j2objc-annotations)
}
