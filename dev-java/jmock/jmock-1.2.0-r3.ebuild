# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library for testing Java code using mock objects"
HOMEPAGE="http://jmock.org/"
SRC_URI="http://jmock.org/downloads/${P}-jars.zip"
S="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="1.0"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos"

CP_DEPEND="dev-java/junit:0"

DEPEND="
	${CP_DEPEND}
	app-arch/unzip
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_SRC_DIR="src"

PATCHES=(
	# This patch isn't changing the behaviour if jmock per se.
	# Only the formatting is altered.
	"${FILESDIR}"/${P}-AbstractMo.patch
)

src_unpack() {
	unpack ${A}
	unzip "${P}"/jmock-core-"${PV}".jar -d src || die
	mv src "${P}" || die
}

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean
}
