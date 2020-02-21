# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A framework to assist in controlling the run-time ClassLoader"
HOMEPAGE="http://forehead.werken.com"
SRC_URI="mirror://gentoo/${P}.tbz2"

LICENSE="Werken-1.1.1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

S="${WORKDIR}/${PN}"

JAVA_SRC_DIR="src"
