# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo edo shell-completion

DESCRIPTION="library for bug, issue, and ticket mangling"
HOMEPAGE="https://github.com/radhermit/bugbite"
SRC_URI="https://github.com/radhermit/bugbite/releases/download/${P}/${P}.tar.xz"
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 CC0-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test ) "

BDEPEND="
	>=virtual/rust-1.75
	test? ( dev-util/cargo-nextest )
"

QA_FLAGS_IGNORED="usr/bin/bite"

src_test() {
	edo cargo nextest run $(usev !debug '--release') --color always --all-features --tests
}

src_install() {
	cargo_src_install

	doman man/*
	dofishcomp shell/bite.fish
	dozshcomp shell/_bite
	newbashcomp shell/bite.bash bite
}
