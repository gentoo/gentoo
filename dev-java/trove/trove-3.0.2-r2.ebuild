# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="GNU Trove: High performance collections for Java"
SRC_URI="mirror://sourceforge/trove4j/${P}.tar.gz"
HOMEPAGE="http://trove4j.sourceforge.net"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

SLOT="0"
LICENSE="LGPL-2.1"
IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.6"

S="${WORKDIR}/${PV}"

RESTRICT="test"

JAVA_SRC_DIR="src"

java_prepare() {
	unzip -d "${P}" "${P}-src.jar" || die
	cp -r "${P}"/* ./src || die
	rm -rf "${P}" || die
	find ./src \
		-type f \
		! -name "*.java" \
		-exec rm -v {} \; || die
	java-pkg_clean
}
