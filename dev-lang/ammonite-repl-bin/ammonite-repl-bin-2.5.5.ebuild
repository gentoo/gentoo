# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Scala language-based scripting and REPL"
HOMEPAGE="https://ammonite.io/"

SRC_URI="
	scala2-13? ( https://github.com/com-lihaoyi/Ammonite/releases/download/${PV}/2.13-${PV} -> ${P}-2.13 )
	scala3-0? ( https://github.com/com-lihaoyi/Ammonite/releases/download/${PV}/3.0-${PV} -> ${P}-3.0 )
	scala3-1? ( https://github.com/com-lihaoyi/Ammonite/releases/download/${PV}/3.1-${PV} -> ${P}-3.1 )
"

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"

S="${WORKDIR}"

RDEPEND=">=virtual/jre-1.8:*"

IUSE="+scala2-13 scala3-0 +scala3-1"
REQUIRED_USE="|| ( scala2-13 scala3-0 scala3-1 )"

src_unpack() {
	:
}

src_install() {
	local last_amm
	if use scala3-1; then
		newbin "${DISTDIR}"/${P}-3.1 amm-3.1
		last_amm=amm-3.1
	fi
	if use scala3-0; then
		newbin "${DISTDIR}"/${P}-3.0 amm-3.0
		last_amm=amm-3.0
	fi
	if use scala2-13; then
		newbin "${DISTDIR}"/${P}-2.13 amm-2.13
		last_amm=amm-2.13
	fi
	dosym $last_amm /usr/bin/amm
}
