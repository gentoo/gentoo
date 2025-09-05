# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple unpacker

DESCRIPTION="Java code for LZMA compression and decompression"
HOMEPAGE="https://7-zip.org/"
SRC_URI="https://7-zip.org/a/lzma${PV/./}.7z -> ${P}.7z"
S="${WORKDIR}/Java"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm64"

BDEPEND="$(unpacker_src_uri_depends)"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="SevenZip"
