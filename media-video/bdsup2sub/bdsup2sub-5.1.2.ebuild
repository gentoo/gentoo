# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="bdsup2sub:bdsup2sub:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A tool to convert and tweak bitmap based subtitle streams"
HOMEPAGE="https://github.com/mjuhasz/BDSup2Sub"
SRC_URI="https://github.com/mjuhasz/BDSup2Sub/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/BDSup2Sub-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/commons-cli:1
	dev-java/java-image-scaling:0
	dev-java/macify:0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_MAIN_CLASS="bdsup2sub.BDSup2Sub"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

src_uppack() {
	unpack "${P}.tar.gz"
}
