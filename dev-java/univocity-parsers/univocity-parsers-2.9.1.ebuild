# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Some test dependencies have not been packaged yet
JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.univocity:univocity-parsers:2.9.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A collection of extremely fast and reliable parsers for Java"
HOMEPAGE="https://www.univocity.com/"
SRC_URI="https://github.com/uniVocity/univocity-parsers/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

# Restore value of S overridden by java-pkg-simple.eclass to default
S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"

src_prepare() {
	# https://github.com/uniVocity/univocity-parsers/pull/502
	eapply "${FILESDIR}/${P}-explicitly-import-Record.patch"
	java-pkg-2_src_prepare
}

src_install() {
	java-pkg-simple_src_install
	einstalldocs # https://bugs.gentoo.org/789582
}
