# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A tool which helps you work with JSR175 annotations"
HOMEPAGE="https://github.com/codehaus/annogen"
SRC_URI="http://dist.codehaus.org/${PN}/distributions/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86"

CDEPEND="
	dev-java/qdox:1.6
	dev-java/ant-core:0
	java-virtuals/jdk-with-com-sun:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

DEPEND="
	${CDEPEND}
	app-arch/unzip
	>=virtual/jre-1.6"

# com.sun.mirror.declaration was removed from JDK 7 onwards.
# These two files are just interfaces anyway.
JAVA_RM_FILES=(
	org/codehaus/annogen/view/MirrorAnnoViewer.java
	org/codehaus/annogen/override/MirrorElementIdPool.java
)

JAVA_GENTOO_CLASSPATH="
	ant-core
	qdox-1.6
"

src_unpack() {
	default
	unzip -o -q "${S}/${PN}-src-${PV}.zip" || die
}

java_prepare() {
	java-pkg_clean
	rm -rf examples || die
}

src_compile() {
	# Needed for com.sun.* imports
	JAVA_GENTOO_CLASSPATH_EXTRA="$(java-config -t)" \
		java-pkg-simple_src_compile
}
