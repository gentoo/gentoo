# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.6.9
ansi_term-0.11.0
atty-0.2.11
bitflags-1.0.4
cc-1.0.29
cfg-if-0.1.6
clap-2.32.0
crossbeam-channel-0.3.8
crossbeam-utils-0.6.5
ctrlc-3.1.1
diff-0.1.11
filetime-0.2.4
fnv-1.0.6
fuchsia-cprng-0.1.1
globset-0.4.2
humantime-1.2.0
ignore-0.4.6
kernel32-sys-0.2.2
lazy_static-1.2.0
libc-0.2.48
log-0.4.6
lscolors-0.5.0
memchr-2.2.0
nix-0.11.0
num_cpus-1.10.0
quick-error-1.2.2
rand-0.4.6
rand_core-0.3.1
rand_core-0.4.0
rdrand-0.4.0
redox_syscall-0.1.51
redox_termios-0.1.1
regex-1.1.0
regex-syntax-0.6.5
remove_dir_all-0.5.1
same-file-1.0.4
smallvec-0.6.8
strsim-0.7.0
tempdir-0.3.7
term_size-0.3.1
termion-1.5.1
textwrap-0.10.0
thread_local-0.3.6
ucd-util-0.1.3
unicode-width-0.1.5
unreachable-1.0.0
utf8-ranges-1.0.2
vec_map-0.8.1
version_check-0.1.5
void-1.0.2
walkdir-2.2.7
winapi-0.2.8
winapi-0.3.6
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

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE=""

DEPEND=">=virtual/rust-1.31.0"
RDEPEND=""

QA_FLAGS_IGNORED="/usr/bin/fd"

src_compile() {
	export SHELL_COMPLETIONS_DIR="${T}/shell_completions"
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
