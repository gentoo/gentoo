# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="JDiskReport helps you to understand disk drive usage"
HOMEPAGE="https://www.jgoodies.com/freeware/jdiskreport/"
SRC_URI="https://www.jgoodies.com/download/jdiskreport2/jdiskreport-${PV//_/}.jar"
S="${WORKDIR}"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"
RDEPEND="<=virtual/jre-21"

src_install() {
	java-pkg_newjar "${DISTDIR}/jdiskreport-${PV//_/}.jar" "${PN}.jar"
	java-pkg_dolauncher jdiskreport-bin
}
