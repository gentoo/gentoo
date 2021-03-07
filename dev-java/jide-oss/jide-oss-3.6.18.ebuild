# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JIDE Common Layer (Professional Swing Components)"
HOMEPAGE="https://github.com/jidesoft/jide-oss"
SRC_URI="https://github.com/jidesoft/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/${P}"

src_prepare() {
	default
	rm -rv libs/ src/com/jidesoft/plaf/aqua/ test/ || die
}

src_install() {
	java-pkg-simple_src_install
	einstalldocs
}
