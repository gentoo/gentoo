# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

LLVM_COMPAT=( {16..18} )

inherit cargo llvm-r1

DESCRIPTION="swiss army knife for chess file formats"
HOMEPAGE="https://git.sr.ht/~alip/jja"

if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://git.sr.ht/~alip/${PN}"
	inherit git-r3
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://git.sr.ht/~alip/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
	"

	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-v${PV}"
fi

# rocksdb needs clang
DEPEND+="$(llvm_gen_dep '
	llvm-core/clang:${LLVM_SLOT}
	llvm-core/llvm:${LLVM_SLOT}
	')
	sys-libs/liburing"
RDEPEND=${DEPEND}
LICENSE="GPL-3+"

# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD CC0-1.0 GPL-3+ ISC MIT Unicode-DFS-2016"
SLOT="0"

pkg_setup() {
	llvm-r1_pkg_setup
	rust_pkg_setup
}

src_unpack() {

	if [[ "${PV}" == "9999" ]] ; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi

}
