# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

MY_PN=${PN/-bin/}

DESCRIPTION="A faster alternative to git-filter-branch for removing bad data from git repos"
HOMEPAGE="https://rtyley.github.io/bfg-repo-cleaner/"
SRC_URI="https://repo1.maven.org/maven2/com/madgag/bfg/${PV}/bfg-${PV}.jar"
S="${WORKDIR}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

src_install() {
	java-pkg_newjar "${DISTDIR}"/${MY_PN}-${PV}.jar
	java-pkg_dolauncher ${PN}
}
