# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

LLVM_COMPAT=( {16..20} )
RUST_MIN_VER="1.79.0"

inherit cargo llvm-r1 shell-completion check-reqs

DESCRIPTION="CLI of the Sequoia OpenPGP implementation"
HOMEPAGE="https://sequoia-pgp.org/ https://gitlab.com/sequoia-pgp/sequoia-sq"
SRC_URI="https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
SRC_URI+=" https://github.com/gentoo-crate-dist/${PN}/releases/download/v${PV}/${P}-crates.tar.xz"
S="${WORKDIR}"/${PN}-v${PV}

LICENSE="LGPL-2.1+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD Boost-1.0 CC0-1.0 ISC LGPL-2+ MIT MIT-0 MPL-2.0
	Unicode-3.0
	|| ( GPL-2 GPL-3 LGPL-3 )
"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64"
IUSE="botan"
CHECKREQS_DISK_BUILD="4G"
CHECKREQS_MEMORY="3G"

COMMON_DEPEND="
	app-arch/bzip2
	dev-db/sqlite:3
	dev-libs/openssl:=
	botan? ( dev-libs/botan:3= )
"
DEPEND="
	${COMMON_DEPEND}
	dev-libs/capnproto
"
RDEPEND="
	${COMMON_DEPEND}
"
# Clang needed for bindgen
BDEPEND="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
	')
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="usr/bin/sq"

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

	# https://wiki.gentoo.org/wiki/Project:Rust/sys_crates#bzip2-sys
	mkdir "${T}/pkg-config" || die
	export PKG_CONFIG_PATH=${T}/pkg-config${PKG_CONFIG_PATH+:${PKG_CONFIG_PATH}}
	cat >> "${T}/pkg-config/bzip2.pc" <<-EOF || die
		Name: bzip2
		Version: 9999
		Description:
		Libs: -lbz2
	EOF

	local myfeatures=(
		$(usex botan crypto-{botan,openssl})
	)

	cargo_src_configure --no-default-features
}

src_install() {
	cargo_src_install

	doman "${asset_dir}"/man-pages/*.1

	local completion_dir="${asset_dir}"/shell-completions
	newbashcomp "${completion_dir}"/sq.bash sq
	dozshcomp "${completion_dir}"/_sq
	dofishcomp "${completion_dir}"/sq.fish
}
