# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

declare -A PKGS=(
	[rime-essay]=e0160b8ef723a423e84ee52b53614ac3382f6d16
	[rime-bopomofo]=1859af68a927ba3cd5afb8c47feedcecf874dab2
	[rime-cangjie]=0ac8452eeb4abbcd8dd1f9e7314012310743285f
	[rime-luna-pinyin]=a53cdf4fd6141cd3a5c2006ae882311e5132fca0
	[rime-prelude]=3c602fdb0dcca7825103e281efc50ef7580f99ec
	[rime-stroke]=3a4b0f4013e2b4c14b1e80c92b1d4723eb65f39c
	[rime-terra-pinyin]=fa30016a9db2cf7d546ce33968c311525f0d90a0
)
declare -A PKGS_EXTRA=(
	[rime-array]=557dbe38381de174fe96e53e9bf8c863a275307c
	[rime-cantonese]=77776c0aad31c78ba743877780fae26f8b1e0dbe
	[rime-combo-pinyin]=711aaa6285216a4e86ec73ecae86a5d6e8fe2a2c
	[rime-double-pinyin]=01a13287cbd27819be1c34fa1ddc1b3643d5001b
	[rime-emoji]=3dd83a264b4686b56abddedecbde75360cbbbfab
	[rime-ipa]=22b71710e029bcb412e9197192a638ab11bc2abf
	[rime-middle-chinese]=582e144e525525ac2b6c2498097d7c7919e84174
	[rime-pinyin-simp]=0c6861ef7420ee780270ca6d993d18d4101049d0
	[rime-quick]=3fe5911ba608cb2df1b6301b76ad1573bd482a76
	[rime-scj]=cab5a0858765eff0553dd685a2d61d5536e9149c
	[rime-soutzoe]=beeaeca72d8e17dfd1e9af58680439e9012987dc
	[rime-stenotype]=bef930831ffe97846fa484a81014ad3e465a25c1
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
# CC-BY-4.0 :
#	rime-cantonese
LICENSE="GPL-3 LGPL-3 extra? ( Apache-2.0 CC-BY-4.0 )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

IUSE="extra"

src_install() {
	insinto "/usr/share/rime-data"

	_install_pkgs() {
		local -n LIST=$1
		local pkg f
		for pkg in "${!LIST[@]}"; do
			doins "${pkg}-${LIST[$pkg]}"/*[!AUTHORS\|LICENSE\|README.md\|check.py]
			for f in AUTHORS LICENSE README.md; do
				if [[ -f "${pkg}-${LIST[$pkg]}/${f}" ]]; then
					newdoc "${pkg}-${LIST[$pkg]}/${f}" "${pkg}_${f}"
				fi
			done
		done
	}

	_install_pkgs PKGS
	use extra && _install_pkgs PKGS_EXTRA
}
