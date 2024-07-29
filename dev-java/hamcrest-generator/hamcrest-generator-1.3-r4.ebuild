# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Code generator for Hamcrest's library of matchers for building test expressions"
HOMEPAGE="https://hamcrest.org/JavaHamcrest/"
SRC_URI="https://github.com/hamcrest/JavaHamcrest/archive/hamcrest-java-${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="${PV}"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~ppc-macos ~x64-macos"

CP_DEPEND="dev-java/qdox:1.12"

DEPEND=">=virtual/jdk-1.8:*
	${CP_DEPEND}"

RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/JavaHamcrest-hamcrest-java-${PV}"

JAVA_SRC_DIR="${PN}/src/main/java"
