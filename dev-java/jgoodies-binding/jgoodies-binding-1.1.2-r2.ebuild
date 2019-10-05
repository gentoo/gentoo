# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

MY_V=${PV//./_}

DESCRIPTION="Bind object properties with UI components"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="BSD"
SLOT="1.0"
KEYWORDS="amd64 x86"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

DOCS=( RELEASE-NOTES.txt README.html )

S="${WORKDIR}/binding-${PV}"

JAVA_SRC_DIR="src/core"

src_prepare() {
	default
	java-pkg_clean
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples \
		src/core \
		src/tutorial
	einstalldocs
}
