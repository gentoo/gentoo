# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java YAML parser and emitter"
HOMEPAGE="https://jvyaml.dev.java.net/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="MIT"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6"

JAVA_SRC_DIR="src"

S="${WORKDIR}/${P}"

java_prepare() {
	java-pkg_clean
	rm -rv src/test || die
}
