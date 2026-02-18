# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

LLVM_COMPAT=( {17..20} )
RUST_MIN_VER="1.79.0"

inherit cargo llvm-r1 shell-completion

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
KEYWORDS="amd64 ~arm64 ~ppc64"
IUSE="botan"

DEPEND="
	botan? ( dev-libs/botan:3= )
	!botan? ( dev-libs/openssl:= )
"
RDEPEND="${DEPEND}"
# Needed for bindgen
BDEPEND="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
	')
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="usr/bin/sqv"

pkg_setup() {
	llvm-r1_pkg_setup
	rust_pkg_setup
}

src_configure() {
	# Set this here so that it doesn't change if we run tests
	# and cause a recompilation.
	asset_dir="${T}"/assets
	export ASSET_OUT_DIR="${asset_dir}"

	# Setting CARGO_TARGET_DIR is required to have the build system
	# create the bash and zsh completion files.
	export CARGO_TARGET_DIR="${S}/target"

	local myfeatures=(
		$(usex botan crypto-{botan,openssl})
	)

	cargo_src_configure --no-default-features
}

src_install() {
	cargo_src_install

	newbashcomp "${asset_dir}"/shell-completions/sqv.bash sqv
	dozshcomp "${asset_dir}"/shell-completions/_sqv
	dofishcomp "${asset_dir}"/shell-completions/sqv.fish

	doman "${asset_dir}"/man-pages/sqv.1
}
