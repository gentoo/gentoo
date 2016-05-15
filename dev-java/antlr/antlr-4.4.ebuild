# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

# List of jar files we need to get from the Internets.
JAR_LIST=(antlr-3.5.2-complete-no-st3.jar antlr-4.3-complete.jar)

DESCRIPTION="A parser generator for C++, C#, Java, and Python"
HOMEPAGE="http://www.antlr.org/"
SRC_URI="https://github.com/${PN}/${PN}4/archive/${PV}.zip
http://www.antlr3.org/download/${JAR_LIST[0]}
http://www.antlr.org/download/${JAR_LIST[1]}"
LICENSE="BSD"
SLOT="4"
KEYWORDS="amd64 ~arm ppc64 x86 ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="gunit"

CDEPEND="
	>=dev-java/stringtemplate-3.2:0
	gunit? ( dev-java/junit:4 )"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="${RDEPEND}
	>=virtual/jdk-1.6"

S="${WORKDIR}/${PN}4-${PV}"

src_prepare() {
	# Disable manual download + lib directory creation.
	epatch "${FILESDIR}"/${P}-build.xml.patch

	# Create lib directory ourselves.
	mkdir "${S}"/lib/

	# Copy downloaded jars in lib directory.
	for myjar in ${JAR_LIST[@]}; do
		cp "${DISTDIR}"/${myjar} "${S}"/lib/
	done
}

src_compile() {
	eant -f build.xml
}

src_install() {
	# Single jar like upstream
	java-pkg_newjar dist/antlr-4.4-complete.jar antlr.jar
	java-pkg_dolauncher antlr4 --main org.antlr.v4.Tool

	if use gunit; then
		java-pkg_dolauncher gunit --main org.antlr.v4.gunit.Interp
	fi

	if use source; then
		java-pkg_dosrc tool/src/org \
			runtime/Java/src/org
	fi
}

pkg_postinst() {
	elog "This ebuild only supports the Java backend for the time being."
}
