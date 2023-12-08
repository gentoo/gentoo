# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=guava-${PV}

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.guava:failureaccess:1.0.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Guava's InternalFutureFailureAccess and InternalFutures classes."
HOMEPAGE="https://github.com/google/guava/"
SRC_URI="https://github.com/google/guava/archive/v${PV}.tar.gz -> guava-${PV}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="futures/${PN}/src/com/google/common/util/concurrent/internal/"
