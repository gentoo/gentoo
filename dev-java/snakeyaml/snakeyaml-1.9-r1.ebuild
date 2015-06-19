# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/snakeyaml/snakeyaml-1.9-r1.ebuild,v 1.1 2013/10/24 18:59:04 tomwij Exp $

EAPI="4"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A YAML 1.1 parser and emitter for Java 5"
HOMEPAGE="http://code.google.com/p/snakeyaml/"
SRC_URI="http://snakeyaml.googlecode.com/files/SnakeYAML-all-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="1.9"
KEYWORDS="amd64 x86"
IUSE=""

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
