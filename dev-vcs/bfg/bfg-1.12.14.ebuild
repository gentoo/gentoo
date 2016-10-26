# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit java-pkg-2

DESCRIPTION="a faster alternative to git-filter-branch for removing bad data from git repos"
HOMEPAGE="http://rtyley.github.io/bfg-repo-cleaner/"
SRC_URI="http://repo1.maven.org/maven2/com/madgag/${PN}/${PV}/${P}.jar"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.6"

S=${WORKDIR}

src_prepare() {
	default
	java-pkg-2_src_prepare
}

src_unpack() { :; }
src_compile() { :; }

src_install() {
	java-pkg_newjar "${DISTDIR}"/${P}.jar
	java-pkg_dolauncher ${PN}
}
