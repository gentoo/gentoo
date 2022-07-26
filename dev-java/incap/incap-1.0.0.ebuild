# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Helper library for building incremental annotation processors"
HOMEPAGE="https://github.com/tbroyer/gradle-incap-helper"
SRC_URI="https://github.com/tbroyer/gradle-incap-helper/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/gradle-incap-helper-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="lib/src/main/java"
