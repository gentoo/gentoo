# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit vcs-snapshot java-pkg-2 java-pkg-simple

DESCRIPTION="Native JNI component for dev-java/jansi"
HOMEPAGE="https://fusesource.github.io/jansi/"
SRC_URI="https://github.com/fusesource/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

CP_DEPEND="dev-java/hawtjni-runtime:0"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8
"

DOCS=( {changelog,readme}.md )

JAVA_SRC_DIR="src/main/java"
