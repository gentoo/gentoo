# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

declare -A PKGS=(
	[rime-essay]=0debef3f5ae37f081758dd8bbd1fe79719410f7c
	[rime-bopomofo]=6085c9a38a4a728047862b33d67eee18aa86f3b9
	[rime-cangjie]=52d90a1b1312e74042b38c1cbc8142defbc53171
	[rime-luna-pinyin]=56b934b099dfbeab842320f13aa8b461a6ab3e42
	[rime-prelude]=082425ea0684bca36474415d4a0e8db9b016487e
	[rime-stroke]=1e8fff9b9494ddec23b0cbc526bcfd8171a6fd48
	[rime-terra-pinyin]=8a2c895ad7ee8e2b137d91be77f18f86b04d7fc9
)
declare -A PKGS_EXTRA=(
	[rime-array]=557dbe38381de174fe96e53e9bf8c863a275307c
	[rime-cantonese]=259f0e48bba840c3a2e0d117539e96937f3d89bc
	[rime-combo-pinyin]=862894a75b6f7bce9038ed6fb8f1e906bb2b1e04
	[rime-double-pinyin]=01a13287cbd27819be1c34fa1ddc1b3643d5001b
	[rime-emoji]=d1dbb424124fc50452a179300c7f287dbcc0db64
	[rime-ipa]=22b71710e029bcb412e9197192a638ab11bc2abf
	[rime-middle-chinese]=582e144e525525ac2b6c2498097d7c7919e84174
	[rime-pinyin-simp]=0c6861ef7420ee780270ca6d993d18d4101049d0
	[rime-quick]=5dcdb9e353d314239e9c8cddc0f42d52da4837bb
	[rime-scj]=cab5a0858765eff0553dd685a2d61d5536e9149c
	[rime-soutzoe]=beeaeca72d8e17dfd1e9af58680439e9012987dc
	[rime-stenotype]=bef930831ffe97846fa484a81014ad3e465a25c1
	[rime-wubi]=152a0d3f3efe40cae216d1e3b338242446848d07
	[rime-wugniu]=2818f4812af3b6f11fc0248fa8918966a3312d2c
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
