# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

RHINO_JAR="lib/rhino-1.7R2.jar"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JavaScript and CSS compressor"
HOMEPAGE="http://yui.github.io/yuicompressor/"
SRC_URI="https://github.com/yui/yuicompressor/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/jargs:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}/${P}"
JAVA_GENTOO_CLASSPATH="jargs"
JAVA_GENTOO_CLASSPATH_EXTRA="${S}/${RHINO_JAR}"
JAVA_SRC_DIR="src"

java_prepare() {
	# Rhino must stay bundled for now.
	rm -v lib/jargs*.jar || die

	# Normally build.xml does this.
	sed -i "s/@VERSION@/${PV}/g" \
		src/com/yahoo/platform/yui/compressor/YUICompressor.java || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_newjar ${RHINO_JAR} rhino.jar # Install this last!!
	java-pkg_dolauncher ${PN} --main com.yahoo.platform.yui.compressor.Bootstrap
}
