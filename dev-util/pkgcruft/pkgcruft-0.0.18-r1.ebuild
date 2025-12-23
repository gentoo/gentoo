# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {19..21} )
RUST_MIN_VER="1.90.0"

inherit cargo edo multiprocessing llvm-r2 shell-completion

DESCRIPTION="QA library and tools based on pkgcraft"
HOMEPAGE="https://pkgcraft.github.io/"

if [[ ${PV} == 9999 ]] ; then
	SCALLOP_VERSION="9999"
	EGIT_REPO_URI="https://github.com/pkgcraft/pkgcraft"
	inherit git-r3
	S="${WORKDIR}"/${P}/crates/${PN}
else
	# For releases, SCALLOP_VERSION must match the value of PACKAGE_VERSION in
	# the vendored library's configure script.
	#
	# To get the value from the repo use the following command:
	# sed -rn "/^PACKAGE_VERSION=/ s/^.*='(.*)'/\1/p" **/scallop/bash/configure
	SCALLOP_VERSION="5.3.9.20251212"
	SRC_URI="https://github.com/pkgcraft/pkgcraft/releases/download/${P}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
# dependent crate licenses
LICENSE+="
	Apache-2.0 BSD-2 BSD CC0-1.0 CDLA-Permissive-2.0 ISC MIT MPL-2.0
"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

# Strict dependency versioning is required since the system library must match
# the vendored copy as scallop exports many parts of bash that aren't meant to
# be a public interface and compatibility is not guaranteed between releases.
RDEPEND="~sys-libs/scallop-${SCALLOP_VERSION}"
DEPEND="${RDEPEND}"
# clang needed by bindgen to generate bash bindings
BDEPEND="
	virtual/pkgconfig
	$(llvm_gen_dep 'llvm-core/clang:${LLVM_SLOT}')
	test? ( dev-util/cargo-nextest )
"

QA_FLAGS_IGNORED="usr/bin/pkgcruft"

pkg_setup() {
	llvm-r2_pkg_setup
	rust_pkg_setup

	# use system scallop library
	export SCALLOP_NO_VENDOR=1
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
		local BIN="${WORKDIR}/${P}/$(cargo_target_dir)/pkgcruft"
		"${BIN}" completion --dir shell || die
	fi
}

src_test() {
	# FAIL [   0.148s] pkgcruft::pkgcruft diff::output
	# FAIL [   0.018s] pkgcruft::pkgcruft show::reports::all
	# FAIL [   0.045s] pkgcruft::pkgcruft show::reports::sets
	unset CLICOLOR CLICOLOR_FORCE

	local -x NEXTEST_TEST_THREADS="$(makeopts_jobs)"

	edo ${CARGO} nextest run $(usev !debug '--release') \
		--color always \
		--tests \
		--no-fail-fast
}

src_install() {
	cargo_src_install

	newbashcomp shell/pkgcruft.bash pkgcruft
	dozshcomp shell/_pkgcruft
	dofishcomp shell/pkgcruft.fish
}
