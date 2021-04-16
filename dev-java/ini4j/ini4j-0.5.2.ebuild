# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit epatch java-pkg-2 java-pkg-simple

DESCRIPTION="Simple Java API Windows style .ini file handling"
HOMEPAGE="http://ini4j.sourceforge.net/"
SRC_URI="http://central.maven.org/maven2/org/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6"

src_prepare() {
	default
	epatch "${FILESDIR}"/"${P}-remove.patch"
}
