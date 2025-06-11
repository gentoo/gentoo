# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=" "
LLVM_COMPAT=( {17..19} )
RUST_MIN_VER="1.85.0"

inherit cargo edo multiprocessing llvm-r1 shell-completion

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
LICENSE+="
	Apache-2.0 BSD-2 BSD CC0-1.0 CDLA-Permissive-2.0 ISC MIT MPL-2.0
	Unicode-3.0
"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test ) "

QA_FLAGS_IGNORED="usr/bin/pk"

# Clang needed for bindgen
BDEPEND="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
	')
	test? ( dev-util/cargo-nextest )
"

pkg_setup() {
	llvm-r1_pkg_setup
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
	cargo_src_compile

	if [[ ${PV} == 9999 ]] ; then
		einfo "Generating shell completions"
		local BIN="${WORKDIR}/${P}/$(cargo_target_dir)/pk"
		"${BIN}" completion --dir shell || die
	fi
}

src_test() {
	unset CLICOLOR CLICOLOR_FORCE

	local -x NEXTEST_TEST_THREADS="$(makeopts_jobs)"

	edo ${CARGO} nextest run $(usev !debug '--release') \
		--color always \
		--tests
}

src_install() {
	cargo_src_install

	newbashcomp shell/pk.bash pk
	dozshcomp shell/_pk
	dofishcomp shell/pk.fish
}
