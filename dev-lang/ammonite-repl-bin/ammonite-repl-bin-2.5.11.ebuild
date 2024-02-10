# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Scala language-based scripting and REPL"
HOMEPAGE="https://ammonite.io/"

SRC_URI="
	scala2-13? ( https://github.com/com-lihaoyi/Ammonite/releases/download/${PV}/2.13-${PV} -> ${P}-2.13 )
	scala3-0? ( https://github.com/com-lihaoyi/Ammonite/releases/download/${PV}/3.0-${PV} -> ${P}-3.0 )
	scala3-1? ( https://github.com/com-lihaoyi/Ammonite/releases/download/${PV}/3.1-${PV} -> ${P}-3.1 )
	scala3-2? ( https://github.com/com-lihaoyi/Ammonite/releases/download/${PV}/3.2-${PV} -> ${P}-3.2 )
"

KEYWORDS="amd64 ~x86"
LICENSE="MIT"
SLOT="0"

S="${WORKDIR}"

RDEPEND=">=virtual/jre-1.8:*"

IUSE="+scala2-13 scala3-0 scala3-1 +scala3-2"

src_unpack() {
	:
}

src_install() {
	local last_amm
	local scala_versions=(2.13 3.{0,1,2})
	local scala_version
	for scala_version in ${scala_versions[@]}; do
		local use_flag=scala${scala_version/./-}

		if ! use ${use_flag}; then
			continue
		fi

		local amm_bin
		amm_bin="amm-${scala_version}"

		newbin "${DISTDIR}/${P}-${scala_version}" ${amm_bin}
		last_amm=${amm_bin}
	done

	dosym $last_amm /usr/bin/amm
}
