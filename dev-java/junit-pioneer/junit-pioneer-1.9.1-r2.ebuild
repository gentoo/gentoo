# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# We cannot run the tests because of too many missing test dependencies.
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JUnit 5 Extension Pack"
HOMEPAGE="https://junit-pioneer.org"
SRC_URI="https://github.com/junit-pioneer/junit-pioneer/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="EPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	>=dev-java/jackson-databind-2.20.0:0
	dev-java/junit:5
	>=virtual/jdk-11:*
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="jackson-databind junit-5"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR=( src/main/{java,module} )
