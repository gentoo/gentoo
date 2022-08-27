# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apiguardian:apiguardian-api:1.1.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="@org.apiguardian.api.API Java annotation provider"
HOMEPAGE="https://github.com/apiguardian-team/apiguardian"
SRC_URI="https://github.com/apiguardian-team/apiguardian/archive/r${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${PN%-api}-r${PV}"

JAVA_SRC_DIR=( src/{main,module}/java )
