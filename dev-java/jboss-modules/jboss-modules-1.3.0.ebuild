# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JBoss modular classloading system"
HOMEPAGE="http://www.jboss.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.Final.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.7"
DEPEND=">=virtual/jdk-1.7"

S="${WORKDIR}/${P}.Final/"

JAVA_SRC_DIR="src/main/java"

java_prepare() {
	rm pom.xml || die
	mkdir -p target/classes || die
	cp -vr "${S}"/src/main/resources/* target/classes/ || die
}
