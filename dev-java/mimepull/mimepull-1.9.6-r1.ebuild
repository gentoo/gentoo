# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Pull API for parsing MIME messages"
HOMEPAGE="http://java.net/projects/mimepull"
SRC_URI="https://repo1.maven.org/maven2/org/jvnet/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=virtual/jdk-1.7"

RDEPEND="
	>=virtual/jre-1.7"
