# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=" "
LLVM_MAX_SLOT=17
inherit edo cargo llvm

DESCRIPTION="pkgcraft-based tools for Gentoo"
HOMEPAGE="https://pkgcraft.github.io/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcraft/pkgcraft"
	inherit git-r3

	S="${WORKDIR}"/${P}/crates/pkgcraft-tools
else
	SRC_URI="https://github.com/pkgcraft/pkgcraft/releases/download/${P}/${P}.tar.xz"

	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD-2 BSD CC0-1.0 GPL-3+ ISC MIT Unicode-DFS-2016"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test ) "

QA_FLAGS_IGNORED="usr/bin/pk"

# Clang needed for bindgen
BDEPEND="
	<sys-devel/clang-$((${LLVM_MAX_SLOT} + 1))
	>=virtual/rust-1.70
	test? ( dev-util/cargo-nextest )
"

llvm_check_deps() {
	has_version -b "sys-devel/clang:${LLVM_SLOT}"
}

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_test() {
	edo cargo nextest run $(usev !debug '--release') --color always --all-features --tests
}
