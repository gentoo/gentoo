# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="SAC is a standard interface for CSS parser"
HOMEPAGE="http://www.w3.org/Style/CSS/SAC/"
SRC_URI="http://www.w3.org/2002/06/sacjava-${PV}.zip -> ${P}.zip"

LICENSE="W3C"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	app-arch/zip
	>=virtual/jdk-1.6"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="org"

src_prepare() {
	default
	java-pkg_clean
}
