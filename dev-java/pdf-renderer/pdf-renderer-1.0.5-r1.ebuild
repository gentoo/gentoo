# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="a 100% Java PDF renderer and viewer"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://repo1.maven.org/maven2/org/swinglabs/${PN}/${PV}/${P}-sources.jar"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"
