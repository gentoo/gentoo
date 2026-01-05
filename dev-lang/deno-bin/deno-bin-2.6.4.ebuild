# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion toolchain-funcs

DESCRIPTION="Modern runtime for JavaScript and TypeScript"
HOMEPAGE="https://deno.com/"
SRC_URI="
	amd64? (
		https://github.com/denoland/deno/releases/download/v${PV}/deno-x86_64-unknown-linux-gnu.zip
			-> ${P}-amd64.zip
	)
	arm64? (
		https://github.com/denoland/deno/releases/download/v${PV}/deno-aarch64-unknown-linux-gnu.zip
			-> ${P}-arm64.zip
	)
"
S=${WORKDIR}

LICENSE="MIT"
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD CC0-1.0 ISC MIT
	MPL-2.0 openssl Unicode-3.0 Unicode-DFS-2016 ZLIB
" # crates
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

RDEPEND="
	|| (
		llvm-runtimes/libgcc
		sys-devel/gcc:*
	)
	sys-libs/glibc
"
BDEPEND="
	app-arch/unzip
"

QA_PREBUILT="usr/bin/deno"

src_compile() {
	if ! tc-is-cross-compiler; then
		./deno completions bash > "${T}"/deno || die
		./deno completions fish > "${T}"/deno.fish || die
		./deno completions zsh > "${T}"/_deno || die
	else
		ewarn "shell completion files were skipped due to cross-compilation"
	fi
}

src_install() {
	dobin deno

	if ! tc-is-cross-compiler; then
		dobashcomp "${T}"/deno
		dofishcomp "${T}"/deno.fish
		dozshcomp "${T}"/_deno
	fi
}
