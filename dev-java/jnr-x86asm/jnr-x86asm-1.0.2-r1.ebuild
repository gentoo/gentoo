# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A pure-java port of asmjit"
HOMEPAGE="https://github.com/jnr/jnr-x86asm"
SRC_URI="https://github.com/jnr/${PN}/archive/${PV}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="1.0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"
JAVA_ANT_ENCODING="UTF-8"
