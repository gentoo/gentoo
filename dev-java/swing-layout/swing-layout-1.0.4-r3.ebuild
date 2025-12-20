# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Professional cross platform layouts with Swing"
HOMEPAGE="https://swing-layout.dev.java.net/"
SRC_URI="mirror://gentoo/${P}-src.zip"
S="${WORKDIR}/${P}"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="amd64"

BDEPEND="app-arch/unzip"
DEPEND="<virtual/jdk-26:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src"
