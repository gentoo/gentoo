# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.jws:jakarta.jws-api:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Web Services Metadata API"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.jaxws"
SRC_URI="https://github.com/jakartaee/jws-api/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/jws-api-${PV}"

LICENSE="BSD"	# (SPDX-License-Identifier: BSD-3-Clause)
SLOT="javax"	# according to namespace
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_RESOURCE_DIRS="api/src/main/resources"
JAVA_SRC_DIR="api/src/main/java"

DOCS=( CONTRIBUTING.md NOTICE.md README.md )
