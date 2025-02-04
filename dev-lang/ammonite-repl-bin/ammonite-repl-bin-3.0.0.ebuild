# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Scala language-based scripting and REPL"
HOMEPAGE="https://ammonite.io/"

MY_COMMIT="2-6342755f"

SRC_URI="
	scala2-13? ( https://github.com/com-lihaoyi/Ammonite/releases/download/${PV}/2.13-${PV}-${MY_COMMIT} -> ${P}-2.13 )
	scala3-3? ( https://github.com/com-lihaoyi/Ammonite/releases/download/${PV}/3.3-${PV}-${MY_COMMIT} -> ${P}-3.3 )
	scala3-5? ( https://github.com/com-lihaoyi/Ammonite/releases/download/${PV}/3.5-${PV}-${MY_COMMIT} -> ${P}-3.5 )
"

S="${WORKDIR}"
LICENSE="MIT"
SLOT="0"

KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND=">=virtual/jre-1.8:*"

IUSE="scala2-13 scala3-3 +scala3-5"

src_unpack() {
	:
}

src_install() {
	local last_amm
	local scala_versions=(2.13 3.{3,5})
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
