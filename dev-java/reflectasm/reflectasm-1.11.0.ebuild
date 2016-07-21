# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="High performance Java reflection"
HOMEPAGE="https://github.com/EsotericSoftware/reflectasm/"
SRC_URI="https://github.com/EsotericSoftware/${PN}/archive/${P}.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

CDEPEND="dev-java/asm:4"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

S="${WORKDIR}/${PN}-${P}"

JAVA_GENTOO_CLASSPATH="
	asm-4
"

java_prepare() {
	java-pkg_clean
	rm -rf test || die
}
