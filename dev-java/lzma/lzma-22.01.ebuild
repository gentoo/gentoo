# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple unpacker

DESCRIPTION="Java code for LZMA compression and decompression"
HOMEPAGE="https://7-zip.org/"
SRC_URI="https://7-zip.org/a/lzma${PV/./}.7z -> ${P}.7z"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"
BDEPEND="$(unpacker_src_uri_depends)"

S="${WORKDIR}/Java"

JAVA_SRC_DIR="SevenZip"
