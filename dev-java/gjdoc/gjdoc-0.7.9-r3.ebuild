# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="source"

inherit eutils autotools java-pkg-2

DESCRIPTION="A javadoc compatible Java source documentation generator"
HOMEPAGE="https://www.gnu.org/software/cp-tools/"
SRC_URI="mirror://gnu/classpath/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"

# Possible USE flags.
#
# native: to --enable-native
# doc:    to generate javadoc
# debug:  There is a debug doclet installed by default but maybe could
#         have a wrapper that uses it.
#
IUSE="xmldoclet"

CDEPEND=">=dev-java/antlr-2.7.1:0[java(+)]"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.4"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.4"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.7.7-gcp.patch"
	epatch "${FILESDIR}/0.7.9-main-execute.patch"
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	# I think that configure will do --enable-native if it finds gcj
	# so we'll disable it explicitly
	local myc="--with-antlr-jar=$(java-pkg_getjar antlr antlr.jar) --disable-native"
	myc="${myc} --disable-dependency-tracking"

	# Does not work with gcc 3.* and without these it tries to use gij
	# see bug #116804 for details

	# TODO ideally, would respect JAVACFLAGS
	JAVA="java" JAVAC="javac $(java-pkg_javac-args)" \
		econf ${myc} \
		$(use_enable xmldoclet)
}

src_compile() {
	default # Don't use from java-pkg-2
}

src_install() {
	local jars="com-sun-tools-doclets-Taglet gnu-classpath-tools-gjdoc com-sun-javadoc"
	for jar in ${jars}; do
		java-pkg_newjar ${jar}-${PV}.jar ${jar}.jar
	done

	java-pkg_dolauncher ${PN} --main gnu.classpath.tools.gjdoc.Main
	dodoc AUTHORS ChangeLog NEWS README

	cd "${S}"/docs
	emake DESTDIR="${D}" install

	use source && java-pkg_dosrc "${S}/src"/{com,gnu}
}
