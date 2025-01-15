# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=" "
LLVM_COMPAT=( {17..19} )
RUST_MIN_VER="1.82.0"

inherit cargo edo llvm-r2 shell-completion toolchain-funcs

DESCRIPTION="QA library and tools based on pkgcraft"
HOMEPAGE="https://pkgcraft.github.io/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcraft/pkgcraft"
	inherit git-r3

	S="${WORKDIR}"/${P}/crates/${PN}
else
	SRC_URI="https://github.com/pkgcraft/pkgcraft/releases/download/${P}/${P}.tar.xz"

	KEYWORDS="~amd64"
fi

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD-2 BSD CC0-1.0 GPL-3+ ISC MIT MPL-2.0 Unicode-DFS-2016
"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

# clang needed for bindgen
BDEPEND+="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
	')
	test? ( dev-util/cargo-nextest )
"

QA_FLAGS_IGNORED="usr/bin/pkgcruft"

pkg_setup() {
	llvm-r2_pkg_setup
	rust_pkg_setup
}

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_compile() {
	# For scallop building bash
	tc-export AR CC

	cargo_src_compile
	edo cargo run --features shell --bin pkgcruft-shell-comp -p pkgcruft
}

src_test() {
	unset CLICOLOR CLICOLOR_FORCE

	edo cargo nextest run $(usev !debug '--release') --color always --all-features --tests
}

src_install() {
	cargo_src_install

	newbashcomp shell/pkgcruft.bash ${PN}
	dozshcomp shell/_pkgcruft
	dofishcomp shell/pkgcruft.fish
}
