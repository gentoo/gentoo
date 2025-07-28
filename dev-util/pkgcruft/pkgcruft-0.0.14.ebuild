# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=" "
LLVM_COMPAT=( {17..20} )
RUST_MIN_VER="1.85.0"

inherit cargo edo llvm-r2 multiprocessing shell-completion toolchain-funcs

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
	Apache-2.0 BSD-2 BSD CC0-1.0 CDLA-Permissive-2.0 ISC MIT MPL-2.0
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

	if [[ ${PV} == 9999 ]] ; then
		einfo "Generating shell completions"
		mkdir shell || die
		local BIN="${WORKDIR}/${P}/$(cargo_target_dir)/pkgcruft"
		"${BIN}" completion bash > shell/pkgcruft.bash || die
		"${BIN}" completion zsh > shell/_pkgcruft || die
		"${BIN}" completion fish > shell/pkgcruft.fish || die
	fi
}

src_test() {
	unset CLICOLOR CLICOLOR_FORCE

	# TODO: Maybe move into eclass (and maybe have a cargo_enable_tests
	# helper)
	local -x NEXTEST_TEST_THREADS="$(makeopts_jobs)"

	# The test failures appear ebuild-related
	edo cargo nextest run $(usev !debug '--release') \
		--color always \
		--all-features \
		--tests \
		--no-fail-fast \
		-- \
		--skip 'commands::tests::check' \
		--skip 'dependency::tests::check' \
		--skip 'dependency_slot_missing::tests::check' \
		--skip 'eapi_stale::tests::check' \
		--skip 'eapi_status::tests::check' \
		--skip 'ebuild_name::tests::check' \
		--skip 'eclass::tests::check' \
		--skip 'filesdir::tests::check' \
		--skip 'header::tests::check' \
		--skip 'homepage::tests::check' \
		--skip 'ignore::tests::check' \
		--skip 'iuse::tests::check' \
		--skip 'keywords::tests::check' \
		--skip 'keywords_dropped::tests::check' \
		--skip 'license::tests::check' \
		--skip 'live::tests::check' \
		--skip 'manifest::tests::check' \
		--skip 'metadata::tests::check' \
		--skip 'properties::tests::check' \
		--skip 'python_update::tests::check' \
		--skip 'repo_layout::tests::check' \
		--skip 'restrict::tests::check' \
		--skip 'restrict_test_missing::tests::check' \
		--skip 'ruby_update::tests::check' \
		--skip 'src_uri::tests::check' \
		--skip 'unstable_only::tests::check' \
		--skip 'use_local::tests::check' \
		--skip 'variable_order::tests::check' \
		--skip 'whitespace::tests::check'
}

src_install() {
	cargo_src_install

	newbashcomp shell/pkgcruft.bash pkgcruft
	dozshcomp shell/_pkgcruft
	dofishcomp shell/pkgcruft.fish
}
