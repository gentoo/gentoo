# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="source" # doc (needs APIviz)

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JBoss modular classloading system"
HOMEPAGE="https://www.jboss.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.Final.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=virtual/jre-1.7"
DEPEND=">=virtual/jdk-1.7"

S="${WORKDIR}/${P}.Final/"

JAVA_SRC_DIR="src/main/java"

src_prepare() {
	default
	rm pom.xml || die
	mkdir -p target/classes || die
	cp -vr "${S}"/src/main/resources/* target/classes/ || die
}
