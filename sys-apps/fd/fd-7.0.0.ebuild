# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.6.4
ansi_term-0.11.0
atty-0.2.8
bitflags-0.9.1
bitflags-1.0.1
cfg-if-0.1.2
clap-2.31.1
crossbeam-0.3.2
ctrlc-3.1.0
diff-0.1.11
fd-find-7.0.0
fnv-1.0.6
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
globset-0.3.0
ignore-0.4.1
kernel32-sys-0.2.2
lazy_static-1.0.0
libc-0.2.39
log-0.4.1
memchr-2.0.1
nix-0.9.0
num_cpus-1.8.0
rand-0.4.2
redox_syscall-0.1.37
redox_termios-0.1.1
regex-0.2.8
regex-syntax-0.5.2
remove_dir_all-0.3.0
same-file-1.0.2
strsim-0.7.0
tempdir-0.3.6
term_size-0.3.1
termion-1.5.1
textwrap-0.9.0
thread_local-0.3.5
ucd-util-0.1.1
unicode-width-0.1.4
unreachable-1.0.0
utf8-ranges-1.0.0
vec_map-0.8.0
version_check-0.1.3
void-1.0.2
walkdir-2.1.4
winapi-0.2.8
winapi-0.3.4
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit bash-completion-r1 cargo

DESCRIPTION="Alternative to find that provides sensible defaults for 80% of the use cases"
HOMEPAGE="https://github.com/sharkdp/fd"
SRC_URI="https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND=">=virtual/rust-1.20.0"
RDEPEND="${DEPEND}"

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

src_test() {
	cargo test -v || die "tests failed"
}
