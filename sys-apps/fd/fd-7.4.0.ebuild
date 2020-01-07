# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.7.6
ansi_term-0.11.0
ansi_term-0.12.1
atty-0.2.13
bitflags-1.1.0
bstr-0.2.8
cc-1.0.45
cfg-if-0.1.9
clap-2.33.0
crossbeam-channel-0.3.9
crossbeam-utils-0.6.6
ctrlc-3.1.3
diff-0.1.11
filetime-0.2.7
fnv-1.0.6
fs_extra-1.1.0
fuchsia-cprng-0.1.1
globset-0.4.4
humantime-1.3.0
ignore-0.4.10
jemalloc-sys-0.3.2
jemallocator-0.3.2
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.62
log-0.4.8
lscolors-0.6.0
memchr-2.2.1
nix-0.14.1
num_cpus-1.10.1
quick-error-1.2.2
rand-0.4.6
rand_core-0.3.1
rand_core-0.4.2
rdrand-0.4.0
redox_syscall-0.1.56
regex-1.3.1
regex-syntax-0.6.12
remove_dir_all-0.5.2
same-file-1.0.5
strsim-0.8.0
tempdir-0.3.7
term_size-0.3.1
textwrap-0.11.0
thread_local-0.3.6
unicode-width-0.1.6
vec_map-0.8.1
version_check-0.9.1
void-1.0.2
walkdir-2.2.9
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.2
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
