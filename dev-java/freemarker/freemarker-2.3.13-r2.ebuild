# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/freemarker/freemarker-2.3.13-r2.ebuild,v 1.2 2015/07/05 12:33:05 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION=" FreeMarker is a template engine; a generic tool to generate text output based on templates"
HOMEPAGE="http://freemarker.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="freemarker"
SLOT="2.3"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

CDEPEND="dev-java/jython:2.7
	java-virtuals/servlet-api:2.3
	java-virtuals/servlet-api:2.4
	java-virtuals/servlet-api:2.5
	dev-java/jaxen:1.1
	dev-java/juel:0"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
	dev-java/javacc:0"

# [0]: Patch so that we can compile the package
# against Jython-2.7.
# [1]: Gentoo specific stuff.
PATCHES=(
	"${FILESDIR}"/${P}-PyJavaInstance.patch
	"${FILESDIR}"/${P}-gentoo.patch
)

java_prepare() {
	# Do away with bundled jar files.
	find -name '*.jar' -exec rm -v {} + || die

	# Apply patches.
	epatch ${PATCHES[@]}

	# Weed out comments (some contain UTF-8 chars javac cannnot deal with).
	sed -i -e '/*/d;' \
		src/freemarker/template/LocalizedString.java

	# For ecj-3.5.
	java-ant_rewrite-bootclasspath auto
}

src_compile() {
	# BIG FAT WARNING:
	# clean target removes lib/ directory!!
	eant clean

	mkdir -p lib/jsp-{1.2,2.0,2.1} || die
	pushd lib >/dev/null || die
	java-pkg_jar-from --virtual --into jsp-1.2 servlet-api-2.3
	java-pkg_jar-from --virtual --into jsp-2.0 servlet-api-2.4
	java-pkg_jar-from --virtual --into jsp-2.1 servlet-api-2.5
	java-pkg_jar-from jaxen-1.1
	java-pkg_jar-from jython-2.7
	java-pkg_jar-from --build-only javacc
	java-pkg_jar-from juel
	popd >/dev/null

	eant jar $(use_doc) -Djavacc.home=/usr/share/javacc/lib
}

src_install() {
	java-pkg_dojar lib/${PN}.jar
	dodoc README.txt

	use doc && java-pkg_dojavadoc build/api
	use source && java-pkg_dosrc src/*
}
