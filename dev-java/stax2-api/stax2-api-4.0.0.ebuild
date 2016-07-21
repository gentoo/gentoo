# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Extended Stax (STandard Api for Xml procesing) API"
HOMEPAGE="https://github.com/FasterXML/stax2-api"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="java-virtuals/stax-api:0
	>=virtual/jre-1.5"

DEPEND="java-virtuals/stax-api:0
	>=virtual/jdk-1.5"

S="${WORKDIR}/${PN}-${P}/src"
JAVA_SRC_DIR="main/java"
JAVA_GENTOO_CLASSPATH="stax-api"

src_install() {
	java-pkg-simple_src_install
	dodoc ../README.md ../release-notes/VERSION
}
