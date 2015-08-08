# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A YAML 1.1 parser and emitter for Java 5"
HOMEPAGE="http://code.google.com/p/snakeyaml/"
SRC_URI="http://snakeyaml.googlecode.com/files/SnakeYAML-all-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${PN}"

JAVA_SRC_DIR="src/main/java"

java_prepare() {
	find "${WORKDIR}" -name '*.class' -exec rm {} +

	# Easier to use java-pkg-simple.
	rm -v pom.xml || die
}

src_install() {
	java-pkg-simple_src_install

	dodoc AUTHORS src/etc/announcement.msg
}
