# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java implementation of the JavaScript Object Notation"
HOMEPAGE="https://github.com/douglascrockford/JSON-java"
SRC_URI="https://github.com/douglascrockford/JSON-java/archive/${PV}.zip -> ${P}.zip"

LICENSE="JSON"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}/JSON-java-${PV}"
JAVA_SRC_DIR="src"

java_prepare() {
	chmod a-x *.java || die
	mkdir -p src || die
	mv *.java src || die
}

src_install() {
	java-pkg-simple_src_install
	dodoc README
}
