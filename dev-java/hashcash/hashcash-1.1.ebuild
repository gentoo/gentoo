# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Generation and parsing of Hashcash"
HOMEPAGE="https://www.nettgryppa.com/code"
SRC_URI="https://www.nettgryppa.com/code/HashCash.java"

LICENSE="GregoryRubin"
SLOT="1"
KEYWORDS="amd64 ~arm64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

src_unpack() {
	cp "${DISTDIR}/${A}" "${S}" || die 'copy source file'
}
