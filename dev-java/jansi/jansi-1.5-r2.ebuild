# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java library to output ANSI escape sequences in console"
HOMEPAGE="http://jansi.fusesource.org/"
SRC_URI="https://github.com/fusesource/${PN}/archive/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 x86"

CDEPEND="dev-java/jansi-native:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}/${PN}-${P}"

JAVA_GENTOO_CLASSPATH="jansi-native"
JAVA_SRC_DIR="src"

src_prepare() {
	default
	rm -rv src/test || die
}
