# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

COMMIT="0eb2fbb739898f55265027c2796f77fbee9f4ab2"

inherit java-pkg-2 java-pkg-simple vcs-snapshot

DESCRIPTION="A small subset of Eclipse core libraries for modular applications"
HOMEPAGE="https://github.com/bardsoftware/eclipsito"
SRC_URI="https://github.com/bardsoftware/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.8"
DEPEND=">=virtual/jdk-1.8"

S="${WORKDIR}/${P}/org.bardsoftware.${PN}"

src_prepare() {
	default
	rm -r src/org/bardsoftware/test || die
}
