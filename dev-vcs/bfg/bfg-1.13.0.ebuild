# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DESCRIPTION="A faster alternative to git-filter-branch for removing bad data from git repos"
HOMEPAGE="https://rtyley.github.io/bfg-repo-cleaner/"
SRC_URI="https://repo1.maven.org/maven2/com/madgag/${PN}/${PV}/${P}.jar"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

S=${WORKDIR}

src_install() {
	java-pkg_newjar "${DISTDIR}"/${P}.jar
	java-pkg_dolauncher ${PN}
}
