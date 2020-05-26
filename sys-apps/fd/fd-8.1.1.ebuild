# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.10
ansi_term-0.11.0
ansi_term-0.12.1
anyhow-1.0.31
arrayref-0.3.6
arrayvec-0.5.1
atty-0.2.14
autocfg-1.0.0
base64-0.11.0
bitflags-1.2.1
blake2b_simd-0.5.10
bstr-0.2.13
cc-1.0.53
cfg-if-0.1.10
clap-2.33.1
constant_time_eq-0.1.5
crossbeam-utils-0.7.2
ctrlc-3.1.4
diff-0.1.12
dirs-2.0.2
dirs-sys-0.3.4
fd-find-8.1.1
filetime-0.2.10
fnv-1.0.7
fs_extra-1.1.0
fuchsia-cprng-0.1.1
getrandom-0.1.14
globset-0.4.5
hermit-abi-0.1.13
humantime-2.0.0
ignore-0.4.15
jemalloc-sys-0.3.2
jemallocator-0.3.2
lazy_static-1.4.0
libc-0.2.70
log-0.4.8
lscolors-0.7.0
memchr-2.3.3
nix-0.17.0
num_cpus-1.13.0
rand-0.4.6
rand_core-0.3.1
rand_core-0.4.2
rdrand-0.4.0
redox_syscall-0.1.56
redox_users-0.3.4
regex-1.3.7
regex-syntax-0.6.17
remove_dir_all-0.5.2
rust-argon2-0.7.0
same-file-1.0.6
strsim-0.8.0
tempdir-0.3.7
term_size-0.3.2
textwrap-0.11.0
thread_local-1.0.1
unicode-width-0.1.7
users-0.10.0
vec_map-0.8.2
version_check-0.9.1
void-1.0.2
walkdir-2.3.1
wasi-0.9.0+wasi-snapshot-preview1
winapi-0.3.8
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit bash-completion-r1 cargo

DESCRIPTION="Alternative to find that provides sensible defaults for 80% of the use cases"
HOMEPAGE="https://github.com/sharkdp/fd"
SRC_URI="https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 BSD-2 ISC MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND="!elibc_musl? ( >=dev-libs/jemalloc-5.1.0:= )"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="/usr/bin/fd"

src_compile() {
	export SHELL_COMPLETIONS_DIR="${T}/shell_completions"
	# this enables to build with system jemallloc, but musl targets do not use it at all
	use elibc_musl || export JEMALLOC_OVERRIDE="${ESYSROOT}/usr/$(get_libdir)/libjemalloc.so"
	cargo_src_compile
}

src_install() {
	cargo_src_install

	newbashcomp "${T}"/shell_completions/fd.bash fd
	insinto /usr/share/zsh/site-functions
	doins "${T}"/shell_completions/_fd
	insinto /usr/share/fish/vendor_completions.d
	doins "${T}"/shell_completions/fd.fish
	dodoc README.md
	doman doc/*.1
}
