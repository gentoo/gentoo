# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java API compatibility testing tools"
HOMEPAGE="http://sab39.netreach.com/japi/"
SRC_URI="http://www.kaffe.org/~stuart/japi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="test"

CDEPEND="dev-java/ant-core:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="ant-core"

JAVA_SRC_DIR="src"

src_install() {
	java-pkg-simple_src_install
	java-pkg_register-ant-task
}
