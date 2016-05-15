# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java library that provides a fluent interface for writing assertions"
HOMEPAGE="http://joel-costigliola.github.io/assertj/"
SRC_URI="https://github.com/joel-costigliola/${PN}/archive/${P}.tar.gz"
LICENSE="Apache-2.0"
KEYWORDS="amd64 x86"
SLOT="2"

CDEPEND="dev-java/cglib:3
	dev-java/junit:4"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.7"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.7"

S="${WORKDIR}/${PN}-${P}"
JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="cglib-3,junit-4"

src_install() {
	java-pkg-simple_src_install
	dodoc {CONTRIBUTING,README}.md
}
