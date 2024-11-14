# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="A debugger for Charm++ applications"
HOMEPAGE="http://charm.cs.uiuc.edu/"
SRC_URI="https://charm.cs.illinois.edu/distrib/binaries/charmdebug/${P/-/_}.tar.gz"

S="${WORKDIR}/${PN}"

LICENSE="charm"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/jre-1.6
	sys-cluster/charm[charmdebug,-smp]
"

src_install() {
	java-pkg_newjar ${PN}.jar
	java-pkg_dolauncher ${PN} \
		--main charm/debug/ParDebug \
		--jar ${PN}.jar \
		--java_args -ms100000000 -mx512000000
}
