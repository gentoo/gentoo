# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java annotation-based framework for parsing Git like command line structures"
HOMEPAGE="https://github.com/airlift/airline/"
# Renaming to avoid conflict with app-vim/airline:
SRC_URI="https://github.com/airlift/${PN}/archive/${PV}.tar.gz -> ${CATEGORY}-${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CP_DEPEND="dev-java/guava:20
	dev-java/javax-inject:0
	dev-java/jsr305:0"

DEPEND=">=virtual/jdk-1.7
	${CP_DEPEND}"

RDEPEND=">=virtual/jre-1.7
	${CP_DEPEND}"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="src/main/java"

src_install() {
	java-pkg-simple_src_install
	dodoc README.md
}
