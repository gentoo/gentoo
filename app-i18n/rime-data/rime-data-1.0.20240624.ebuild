# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

declare -A PKGS=(
	[rime-essay]=e0519d0579722a0871efb68189272cba61a7350b
	[rime-bopomofo]=c7618f4f5728e1634417e9d02ea50d82b71956ab
	[rime-cangjie]=0ac8452eeb4abbcd8dd1f9e7314012310743285f
	[rime-luna-pinyin]=44e555d1090a56d62a41a58153088406bcf87abd
	[rime-prelude]=3803f09458072e03b9ed396692ce7e1d35c88c95
	[rime-stroke]=65fdbbf2f9485cc907cb9a6d6b9210938a50f71e
	[rime-terra-pinyin]=9df66c7edc9474a945e9f4744419b156278d1580
)
declare -A PKGS_EXTRA=(
	[rime-array]=557dbe38381de174fe96e53e9bf8c863a275307c
	[rime-combo-pinyin]=20cc1be16f5886e1a6b2bcb1c70010b5e0d8d61f
	[rime-double-pinyin]=69bf85d4dfe8bac139c36abbd68d530b8b6622ea
	[rime-emoji]=be7d308e42c4c4485229de37ec0afb7bafbfafc0
	[rime-ipa]=22b71710e029bcb412e9197192a638ab11bc2abf
	[rime-middle-chinese]=582e144e525525ac2b6c2498097d7c7919e84174
	[rime-pinyin-simp]=52b9c75f085479799553f2499c4f4c611d618cdf
	[rime-quick]=3fe5911ba608cb2df1b6301b76ad1573bd482a76
	[rime-scj]=cab5a0858765eff0553dd685a2d61d5536e9149c
	[rime-soutzoe]=beeaeca72d8e17dfd1e9af58680439e9012987dc
	[rime-stenotype]=f3e9189d5ce33c55d3936cc58e39d0c88b3f0c88
	[rime-wubi]=152a0d3f3efe40cae216d1e3b338242446848d07
	[rime-wugniu]=abd1ee98efbf170258fcf43875c21a4259e00b61
)

generate_src_uri() {
	local -n LIST=$1
	local pkg
	for pkg in "${!LIST[@]}"; do
		SRC_URI+=" https://github.com/rime/${pkg}/archive/${LIST[$pkg]}.tar.gz -> ${pkg}-${PV}.tar.gz"
	done
}

DESCRIPTION="Data resources for Rime Input Method Engine"
HOMEPAGE="https://rime.im/ https://github.com/rime/plum"

generate_src_uri PKGS
SRC_URI+=" extra? ( "
generate_src_uri PKGS_EXTRA
SRC_URI+=" )"

S=${WORKDIR}

# LGPL-3 :
#	essay bopomofo cangjie emoji ipa
#	luna-pinyin prelude quick stroke terra-pinyin wubi
# GPL-3 :
#	array combo-pinyin double-pinyin middle-chinese
#	scj soutzoe stenotype wugniu
# Apache-2 :
#	rime-pinyin-simp
LICENSE="GPL-3 LGPL-3 extra? ( Apache-2.0 )"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ppc ppc64 ~riscv x86"

IUSE="extra"

src_install() {
	insinto "/usr/share/rime-data"

	_install_pkgs() {
		local -n LIST=$1
		local pkg f
		for pkg in "${!LIST[@]}"; do
			doins "${pkg}-${LIST[$pkg]}"/*[!AUTHORS\|LICENSE\|README.md\|check.py]
			for f in AUTHORS LICENSE README.md; do
				newdoc "${pkg}-${LIST[$pkg]}/${f}" "${pkg}_${f}"
			done
		done
	}

	_install_pkgs PKGS
	use extra && _install_pkgs PKGS_EXTRA
}
