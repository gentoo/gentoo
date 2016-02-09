# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JavaScript and CSS compressor"
HOMEPAGE="http://yui.github.io/yuicompressor/"
SRC_URI="https://github.com/yui/yuicompressor/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/jargs:0
	dev-java/rhino:1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="
	jargs
	rhino-1.6
"

JAVA_SRC_DIR="src"

java_prepare() {
	java-pkg_clean
}
