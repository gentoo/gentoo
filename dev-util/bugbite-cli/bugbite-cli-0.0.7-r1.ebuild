# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo edo shell-completion

DESCRIPTION="A command line tool for bug, issue, and ticket mangling"
HOMEPAGE="https://github.com/radhermit/bugbite"
SRC_URI="https://github.com/radhermit/bugbite/releases/download/${P}/${P}.tar.xz"
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 CC0-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="static test"
RESTRICT="!test? ( test ) "

BDEPEND="
	>=virtual/rust-1.75
	test? ( dev-util/cargo-nextest )
"

QA_FLAGS_IGNORED="usr/bin/bite"

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && use static ; then
		local rust_target=$( rustc -vV 2>/dev/null | sed -n 's|^host: ||p' )
		[[ -z ${rust_target} ]] && die "Failed to read host target from rustc!"
		export RUSTFLAGS="-C target-feature=+crt-static ${RUSTFLAGS}"
		export static_stuff="--target ${rust_target}"
	fi
}

src_configure() {
		cargo_src_configure ${static_stuff}
}

src_test() {
	edo cargo nextest run $(usev !debug '--release') --color always --all-features --tests ${static_stuff}
}

src_install() {
	cargo_src_install

	doman man/*
	dofishcomp shell/bite.fish
	dozshcomp shell/_bite
	newbashcomp shell/bite.bash bite
}
