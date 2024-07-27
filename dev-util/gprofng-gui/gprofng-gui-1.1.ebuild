# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="full-fledged graphical interface to operate gprofng"
HOMEPAGE="https://www.gnu.org/software/gprofng-gui/"
SRC_URI="https://ftp.gnu.org/gnu/gprofng-gui/${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

src_compile() {
	ejavac $(find org/gprofng/analyzer -name '*.java')
	ejavac $(find org/gprofng/collector -name '*.java')
	ejavac $(find org/gprofng/mpmt -name '*.java')

	find org -type f -name '*.java' -exec rm -rf {} + || die

	"$(java-config -j)" cfm gprofng-analyzer.jar analyzer_st.mf -C . org/gprofng/analyzer || die
	"$(java-config -j)" cfm gprofng-collector.jar gprofng-collector.mf -C . org/gprofng/collector || die
	"$(java-config -j)" cfm gprofng.jar gprofng-gui.mf -C . org/gprofng/mpmt || die
}

src_install() {
	java-pkg_dojar gprofng{,-analyzer,-collector}.jar
	java-pkg_dolauncher gp-display-gui --main org.gprofng.analyzer.AnMain
}
