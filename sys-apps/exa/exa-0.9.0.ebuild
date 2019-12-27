# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.3
ansi_term-0.12.0
atty-0.2.11
autocfg-0.1.4
bitflags-1.0.4
byteorder-1.3.2
cc-1.0.35
cfg-if-0.1.7
datetime-0.4.7
env_logger-0.6.1
exa-0.9.0
git2-0.9.1
glob-0.3.0
humantime-1.2.0
idna-0.1.5
iso8601-0.1.1
kernel32-sys-0.2.2
lazy_static-1.3.0
libc-0.2.51
libgit2-sys-0.8.1
libz-sys-1.0.25
locale-0.2.2
log-0.4.6
matches-0.1.8
memchr-2.2.0
natord-1.0.9
nom-1.2.4
num-traits-0.1.43
num-traits-0.2.6
num_cpus-1.10.0
number_prefix-0.3.0
openssl-src-111.3.0+1.1.1c
openssl-sys-0.9.47
pad-0.1.5
percent-encoding-1.0.1
pkg-config-0.3.14
quick-error-1.2.2
redox_syscall-0.1.54
redox_termios-0.1.1
regex-1.1.6
regex-syntax-0.6.6
scoped_threadpool-0.1.9
smallvec-0.6.9
term_grid-0.1.7
term_size-0.3.1
termcolor-1.0.4
termion-1.5.1
thread_local-0.3.6
ucd-util-0.1.3
unicode-bidi-0.3.4
unicode-normalization-0.1.8
unicode-width-0.1.5
url-1.7.2
users-0.9.1
utf8-ranges-1.0.2
vcpkg-0.2.6
winapi-0.2.8
winapi-0.3.7
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.2
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.1
zoneinfo_compiled-0.4.8
"

inherit bash-completion-r1 cargo

DESCRIPTION="A modern replacement for 'ls' written in Rust"
HOMEPAGE="https://the.exa.website/"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="+git"

DEPEND="
	git? (
		dev-libs/libgit2:=
		net-libs/http-parser:=
	)
"

RDEPEND="${DEPEND}"

RESTRICT="test"

QA_FLAGS_IGNORED="/usr/bin/exa"

src_compile() {
	cargo_src_compile $(usex git "" --no-default-features)
}

src_install() {
	cargo_src_install $(usex git "" --no-default-features)

	newbashcomp contrib/completions.bash exa

	insinto /usr/share/zsh/site-functions
	newins contrib/completions.zsh _exa

	insinto /usr/share/fish/vendor_completions.d
	newins contrib/completions.fish exa.fish

	doman contrib/man/*
}
