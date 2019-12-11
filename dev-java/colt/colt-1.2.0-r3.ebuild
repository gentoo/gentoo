# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Java Libraries for High Performance Scientific and Technical Computing"
SRC_URI="http://dsd.lbl.gov/~hoschek/colt-download/releases/${P}.tar.gz"
HOMEPAGE="http://www-itg.lbl.gov/~hoschek/colt/"

LICENSE="colt"
IUSE=""
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}/${PN}"

EANT_BUILD_TARGET="javac jar"
JAVA_ANT_ENCODING="ISO-8859-1"

# [0]: I don't know but it must be useful.
# [1]: Monkey patch manually some classes to get rid of the
# oswego.edu.concurrent.util imports.
PATCHES=(
	"${FILESDIR}/${P}-benchmark-no-deprecation.patch"
	"${FILESDIR}/${P}-remove-concurrent-util-imports.patch"
)

java_prepare() {
	epatch "${PATCHES[@]}"
	java-pkg_clean
}

src_install() {
	java-pkg_dojar "lib/${PN}.jar"

	dohtml README.html
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/*
}
