# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.5.3
ansi_term-0.8.0
bitflags-0.7.0
bitflags-0.9.1
byteorder-0.4.2
cmake-0.1.25
conv-0.3.3
custom_derive-0.1.7
datetime-0.4.5
env_logger-0.3.5
exa-0.8.0
gcc-0.3.53
getopts-0.2.14
git2-0.6.8
glob-0.2.11
idna-0.1.4
iso8601-0.1.1
kernel32-sys-0.2.2
lazy_static-0.2.8
libc-0.2.30
libgit2-sys-0.6.14
libz-sys-1.0.16
locale-0.2.2
log-0.3.8
magenta-0.1.1
magenta-sys-0.1.1
matches-0.1.6
memchr-0.1.11
natord-1.0.9
nom-1.2.4
num-0.1.40
num-bigint-0.1.40
num-complex-0.1.40
num-integer-0.1.35
num-iter-0.1.34
num-rational-0.1.39
num-traits-0.1.40
num_cpus-1.6.2
number_prefix-0.2.7
pad-0.1.4
percent-encoding-1.0.0
pkg-config-0.3.9
rand-0.3.16
redox_syscall-0.1.31
regex-0.1.80
regex-syntax-0.3.9
rustc-serialize-0.3.24
scoped_threadpool-0.1.7
term_grid-0.1.6
term_size-0.3.0
thread-id-2.0.0
thread_local-0.2.7
unicode-bidi-0.3.4
unicode-normalization-0.1.5
unicode-width-0.1.4
url-1.5.1
users-0.5.3
utf8-ranges-0.1.3
vcpkg-0.2.2
winapi-0.2.8
winapi-build-0.1.1
zoneinfo_compiled-0.4.5
"

inherit bash-completion-r1 cargo

DESCRIPTION="A modern replacement for 'ls' written in Rust"
HOMEPAGE="https://the.exa.website/"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
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
