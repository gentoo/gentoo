# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A parser generator for many languages"
HOMEPAGE="http://www.antlr2.org/"
SRC_URI="http://www.antlr2.org/download/${P}.tar.gz"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples source"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	source? ( app-arch/zip )"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="${S}/${PN}"

java_prepare() {
	java-pkg_clean

	# Delete build files from examples.
	find examples \( -name Makefile.in -o -name shiplist \) -delete || die
}

src_configure() {
	: # Avoid configure script.
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher antlr --main antlr.Tool
	dodoc {CHANGES,README}.txt

	use doc && java-pkg_dohtml -r doc/*
	use examples && java-pkg_doexamples examples/java
	use source && java-pkg_dosrc antlr
}
