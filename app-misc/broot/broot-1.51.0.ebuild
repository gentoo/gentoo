# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85.0"
inherit cargo shell-completion

DESCRIPTION="A new way to see and navigate directory trees"
HOMEPAGE="https://dystroy.org/broot/ https://github.com/Canop/broot"
SRC_URI="https://github.com/Canop/broot/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/broot/releases/download/v${PV}/${P}-crates.tar.xz"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD Boost-1.0
	LGPL-3+ MIT MPL-2.0 UoI-NCSA Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="amd64"
IUSE="X"

DEPEND="
	dev-db/sqlite:3
	dev-libs/libgit2:=
	virtual/zlib:=
	X? ( x11-libs/libxcb:= )
"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	default

	local mandate=$(date -r man/page +'%Y/%m/%d' || die)
	sed -e "s|#version|${PV}|" \
		-e "s|#date|${mandate}|" \
		man/page > "${T}"/${PN}.1 || die
}

src_configure() {
	export LIBSQLITE3_SYS_USE_PKG_CONFIG=1
	export RUSTFLAGS="-Cstrip=none ${RUSTFLAGS}" #835400
	local myfeatures=( $(usev X clipboard) )

	cargo_src_configure --no-default-features
}

src_install() {
	cargo_src_install

	doman "${T}"/${PN}.1

	local build_dir=( "$(cargo_target_dir)"/build/${PN}-*/out )
	cd ${build_dir[0]} || die

	newbashcomp ${PN}.bash ${PN}
	newbashcomp br.bash br

	dozshcomp _${PN} _br
	dofishcomp ${PN}.fish br.fish
}
