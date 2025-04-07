# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

LLVM_COMPAT=( {17..19} )
RUST_NEEDS_LLVM=1

inherit bash-completion-r1 cargo llvm-r1

DESCRIPTION="A simple OpenPGP signature verification program"
HOMEPAGE="https://sequoia-pgp.org/ https://gitlab.com/sequoia-pgp/sequoia-sqv"
SRC_URI="
	https://gitlab.com/sequoia-pgp/sequoia-sqv/-/archive/v${PV}/${PN}-v${PV}.tar.bz2
	${CARGO_CRATE_URIS}
"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-crates.tar.xz"
S="${WORKDIR}"/${PN}-v${PV}

LICENSE="GPL-2+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD Boost-1.0 CC0-1.0 ISC LGPL-2+ MIT Unicode-3.0
	|| ( GPL-2 GPL-3 LGPL-3 )
"
SLOT="0"
KEYWORDS="amd64 ~ppc64"

QA_FLAGS_IGNORED="usr/bin/sqv"

COMMON_DEPEND="
	dev-libs/gmp:=
	dev-libs/nettle:=
"

DEPEND="
	${COMMON_DEPEND}
"
RDEPEND="${COMMON_DEPEND}"
# Needed for bindgen
BDEPEND="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
	')
	virtual/pkgconfig
"

pkg_setup() {
	llvm-r1_pkg_setup
	rust_pkg_setup
}

src_compile() {
	# Set this here so that it doesn't change if we run tests
	# and cause a recompilation.
	asset_dir="${T}"/assets
	export ASSET_OUT_DIR="${asset_dir}"

	# Setting CARGO_TARGET_DIR is required to have the build system
	# create the bash and zsh completion files.
	export CARGO_TARGET_DIR="${S}/target"

	cargo_src_compile
}

src_install() {
	cargo_src_install

	newbashcomp "${asset_dir}"/shell-completions/sqv.bash sqv

	doman "${asset_dir}"/man-pages/sqv.1

	insinto /usr/share/zsh/site-functions
	doins "${asset_dir}"/shell-completions/_sqv

	insinto /usr/share/fish/vendor_completions.d
	doins "${asset_dir}"/shell-completions/sqv.fish
}
