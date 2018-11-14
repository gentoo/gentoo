# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Implementation of xz data compression in pure java"
HOMEPAGE="https://tukaani.org/xz/java.html"
SRC_URI="https://tukaani.org/xz/${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

EANT_DOC_TARGET="doc"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}/${PN}-stop-fetching-external-files.patch"
)

src_prepare() {
	default
	java-utils-2_src_prepare
}

src_install() {
	java-pkg_dojar build/jar/xz.jar
	use doc && java-pkg_dojavadoc build/doc
	use examples && java-pkg_doexamples src/*Demo.java
	use source && java-pkg_dosrc src/org
}
