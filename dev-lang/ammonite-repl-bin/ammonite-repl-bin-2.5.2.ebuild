# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SCALA_VERSION="2.13"

DESCRIPTION="Scala language-based scripting and REPL"
HOMEPAGE="https://ammonite.io/"
SRC_URI="https://github.com/com-lihaoyi/Ammonite/releases/download/${PV}/${SCALA_VERSION}-${PV} -> ${P}"

KEYWORDS="amd64 x86"
LICENSE="MIT"
SLOT="0"

S="${WORKDIR}"

RDEPEND=">=virtual/jre-1.8:*"

src_unpack() {
	:
}

src_install() {
	newbin "${DISTDIR}"/${P} amm
}
