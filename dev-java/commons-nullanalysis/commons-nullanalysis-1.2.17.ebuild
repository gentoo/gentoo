# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="de.unkrig.commons:commons-nullanalysis:1.2.17"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Annotations and utility classes for ECLIPSE annotation-base null analysis"
HOMEPAGE="https://unkrig.de/w/Commons.unkrig.de"
SRC_URI="https://github.com/aunkrig/commons/archive/V${PV}.tar.gz -> unkrig-commons${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/commons-${PV}/commons-nullanalysis"

JAVA_SRC_DIR="src/main/java"
