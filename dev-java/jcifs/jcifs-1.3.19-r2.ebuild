# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library that implements the CIFS/SMB networking protocol in Java"
SRC_URI="https://jcifs.samba.org/src/${P}.tgz"
HOMEPAGE="https://jcifs.samba.org/"
S="${WORKDIR}/${P/-/_}"

LICENSE="LGPL-2.1"
SLOT="1.1"

KEYWORDS="~amd64 ~ppc64 ~x86"

CP_DEPEND="dev-java/jakarta-servlet-api:4"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*"

JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="src"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean
	mkdir -p res || die
	cd src || die
	find . -type f -name '*.css' -o -name '*.map' \
	| xargs cp --parents -v -t ../res || die
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples examples
}
