# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.beust:jcommander:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Command line parsing framework for Java"
HOMEPAGE="https://jcommander.org/"
SRC_URI="https://github.com/cbeust/jcommander/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="1.64"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"
