# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="JavaScript and CSS compressor"
HOMEPAGE="http://yui.github.io/yuicompressor/"
SRC_URI="https://github.com/yui/yuicompressor/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

src_compile(){
	eant
}

src_install() {
	java-pkg_newjar "build/${P}.jar" "${PN}.jar"
	java-pkg_dolauncher "${PN}"
}
