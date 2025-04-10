# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.84.0"

inherit cargo edo multiprocessing shell-completion

DESCRIPTION="A command line tool for bug, issue, and ticket mangling"
HOMEPAGE="https://github.com/radhermit/bugbite"
SRC_URI="https://github.com/radhermit/bugbite/releases/download/${P}/${P}.tar.xz"
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 CC0-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="openssl static test"
RESTRICT="!test? ( test ) "

BDEPEND="
	openssl? (
		!static? ( dev-libs/openssl:= )
		static? ( dev-libs/openssl:=[static-libs] )
	)
	test? ( dev-util/cargo-nextest )
"

RDEPEND="
	openssl? (
		!static? ( dev-libs/openssl:= )
	)
"

QA_FLAGS_IGNORED="usr/bin/bite"

pkg_setup() {
	rust_pkg_setup
	if [[ ${MERGE_TYPE} != binary ]] && use static ; then
		local rust_target=$( rustc -vV 2>/dev/null | sed -n 's|^host: ||p' )
		[[ -z ${rust_target} ]] && die "Failed to read host target from rustc!"
		export RUSTFLAGS="-C target-feature=+crt-static ${RUSTFLAGS}"
		export static_stuff="--target ${rust_target}"
	fi
}

src_configure() {
	local myfeatures=(
		$(usev openssl native-tls)
	)
	cargo_src_configure --no-default-features ${static_stuff}
}

src_test() {
	local -x NEXTEST_TEST_THREADS="$(makeopts_jobs)"
	edo cargo nextest run $(usev !debug '--release') --color always --features test --tests ${static_stuff}
}

src_install() {
	cargo_src_install

	doman man/*
	dofishcomp shell/bite.fish
	dozshcomp shell/_bite
	newbashcomp shell/bite.bash bite
}
