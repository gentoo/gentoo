# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.inject:jakarta.inject-tck:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Dependency Injection (DI) TCK"
HOMEPAGE="https://jakarta.ee/specifications/dependency-injection/"
MY_COMMIT="4b49b49114ba5a0891192e9afac12c0adce7a9d9"
SRC_URI="https://github.com/jakartaee/inject-tck/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/inject-tck-${MY_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/injection-api:0
	dev-java/junit:4
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_SRC_DIR="src/main/java"
