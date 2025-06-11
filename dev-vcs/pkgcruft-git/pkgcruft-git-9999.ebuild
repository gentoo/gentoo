# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=" "
LLVM_COMPAT=( {17..20} )
RUST_MIN_VER="1.85.0"

inherit cargo edo llvm-r2 multiprocessing toolchain-funcs

DESCRIPTION="QA support for verifying git commits via pkgcruft"
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
	Unicode-3.0
"
SLOT="0"
IUSE="test"
# Fails to link w/ missing libssh2 with some CFLAGS
RESTRICT="!test? ( test ) test"

DEPEND="
	dev-libs/libgit2:=
	dev-libs/openssl:=
"
RDEPEND="${DEPEND}"
# clang needed for bindgen
BDEPEND+="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
	')
	test? ( dev-util/cargo-nextest )
"

QA_FLAGS_IGNORED="usr/bin/pkgcruft-git"

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
}

src_test() {
	unset CLICOLOR CLICOLOR_FORCE

	# TODO: Maybe move into eclass (and maybe have a cargo_enable_tests
	# helper)
	local -x NEXTEST_TEST_THREADS="$(makeopts_jobs)"

	edo cargo nextest run $(usev !debug '--release') \
		--color always \
		--tests \
		--no-fail-fast
}
