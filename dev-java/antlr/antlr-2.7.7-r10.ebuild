# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source"
MAVEN_ID="antlr:antlr:2.7.7"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A parser generator for many languages"
HOMEPAGE="https://www.antlr2.org/"
SRC_URI="https://www.antlr2.org/download/${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos ~x64-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_MAIN_CLASS="antlr.Tool"
JAVA_SRC_DIR="${S}/${PN}"

DOCS=( CHANGES.txt README.txt )

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean

	# Delete build files from examples.
	find examples \( -name Makefile.in -o -name shiplist \) -delete || die
}

# Avoid configure script.
src_configure() { :; }

src_install() {
	java-pkg-simple_src_install

	use doc && java-pkg_dohtml -r doc/*
	use examples && java-pkg_doexamples examples/java
	use source && java-pkg_dosrc antlr
}
