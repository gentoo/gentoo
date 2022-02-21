# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://codeload.github.com/google/guava/tar.gz/refs/tags/v30.1.1 --slot 0 --keywords "" --ebuild failureacess-30.1.1.ebuild

EAPI=7

MY_P=guava-${PV}

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.guava:failureaccess:1.0.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Guava's InternalFutureFailureAccess and InternalFutures classes."
HOMEPAGE="https://github.com/google/guava/failureaccess"
SRC_URI="https://codeload.github.com/google/guava/tar.gz/refs/tags/v${PV} -> ${MY_P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${MY_P}"

JAVA_SRC_DIR="futures/${PN}/src/com/google/common/util/concurrent/internal/"
