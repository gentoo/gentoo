# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

RUST_MIN_VER="1.85.0"
LLVM_COMPAT=( {16..21} )

inherit cargo llvm-r1 shell-completion check-reqs

DESCRIPTION="Implementation of the Stateless OpenPGP Command Line Interface using Sequoia"
HOMEPAGE="https://sequoia-pgp.org/ https://gitlab.com/sequoia-pgp/sequoia-sop"
SRC_URI="https://gitlab.com/sequoia-pgp/sequoia-sop/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-crates.tar.xz"
S="${WORKDIR}"/${PN}-v${PV}

LICENSE="GPL-2+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD Boost-1.0 CC0-1.0 ISC LGPL-2+ MIT MPL-2.0 Unicode-3.0
	ZLIB
	|| ( GPL-2 GPL-3 LGPL-3 )
"
SLOT="0"
KEYWORDS="amd64"
IUSE="botan"
CHECKREQS_DISK_BUILD="2G"
CHECKREQS_MEMORY="2G"

QA_FLAGS_IGNORED="usr/bin/sqop"

COMMON_DEPEND="
	app-arch/bzip2
	dev-db/sqlite:3
	dev-libs/gmp:=
	dev-libs/nettle:=
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

	# https://wiki.gentoo.org/wiki/Project:Rust/sys_crates#bzip2-sys
	mkdir "${T}/pkg-config" || die
	export PKG_CONFIG_PATH=${T}/pkg-config${PKG_CONFIG_PATH+:${PKG_CONFIG_PATH}}
	cat >> "${T}/pkg-config/bzip2.pc" <<-EOF || die
	Name: bzip2
	Version: 9999
	Description:
	Libs: -lbz2
	EOF

	cargo_src_compile
}

src_configure() {
	local myfeatures=(
		cli
		$(usex botan crypto-{botan,openssl})
	)

	cargo_src_configure --no-default-features
}

src_install() {
	cargo_src_install

	doman "${asset_dir}"/man-pages/*.1

	local completion_dir="${asset_dir}"/shell-completions
	newbashcomp "${completion_dir}"/sqop.bash sqop
	dozshcomp "${completion_dir}"/_sqop
	dofishcomp "${completion_dir}"/sqop.fish
}
