# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.10
arc-swap-0.4.6
atty-0.2.14
backtrace-0.3.46
backtrace-sys-0.1.37
bitflags-1.2.1
cc-1.0.52
cfg-if-0.1.10
cpuprofiler-0.0.4
env_logger-0.5.13
error-chain-0.12.2
failure-0.1.7
failure_derive-0.1.7
fuse-0.3.1
getopts-0.2.21
getrandom-0.1.14
hermit-abi-0.1.12
humantime-1.3.0
itoa-0.4.5
lazy_static-1.4.0
libc-0.2.69
log-0.3.9
log-0.4.8
memchr-2.3.3
nix-0.12.1
num_cpus-1.13.0
pkg-config-0.3.17
ppv-lite86-0.2.6
proc-macro2-1.0.12
quick-error-1.2.3
quote-1.0.4
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
redox_syscall-0.1.56
regex-1.3.7
regex-syntax-0.6.17
remove_dir_all-0.5.2
rustc-demangle-0.1.16
ryu-1.0.4
sandboxfs-0.2.0
serde-1.0.106
serde_derive-1.0.106
serde_json-1.0.52
signal-hook-0.1.14
signal-hook-registry-1.2.0
syn-1.0.18
synstructure-0.12.3
tempfile-3.1.0
termcolor-1.1.0
thread-scoped-1.0.2
thread_local-1.0.1
threadpool-1.8.0
time-0.1.43
unicode-width-0.1.7
unicode-xid-0.2.0
users-0.9.1
version_check-0.9.1
void-1.0.2
wasi-0.9.0+wasi-snapshot-preview1
winapi-0.3.8
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
xattr-0.2.2
"

inherit cargo

DESCRIPTION="A virtual file system for sandboxing"
HOMEPAGE="https://github.com/bazelbuild/sandboxfs"
SRC_URI="https://github.com/bazelbuild/sandboxfs/archive/${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="profile"

DEPEND="
	sys-fs/fuse:0
	profile? ( dev-util/google-perftools )
"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

QA_FLAGS_IGNORED="/usr/bin/sandboxfs"

S="${WORKDIR}/${PN}-${P}"

src_configure() {
	myfeatures=(
		$(usex profile profiling '')
	)
}

src_compile() {
	cargo_src_compile ${myfeatures:+--features "${myfeatures[*]}"}
}

src_install() {
	mv man _man || die
	cargo_src_install ${myfeatures:+--features "${myfeatures[*]}"}
	doman _man/"${PN}.1"
	einstalldocs
}
