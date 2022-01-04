# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java code for LZMA compression and decompression"
HOMEPAGE="https://www.7-zip.org/"
SRC_URI="https://www.7-zip.org/a/${PN}${PV/./}.7z"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"
BDEPEND="app-arch/p7zip"

S="${WORKDIR}/Java"

JAVA_SRC_DIR="SevenZip"
