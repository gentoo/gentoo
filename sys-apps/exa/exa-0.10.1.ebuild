# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
ansi_term-0.12.1
autocfg-1.0.1
bitflags-1.2.1
byteorder-1.4.3
cc-1.0.67
cfg-if-1.0.0
datetime-0.5.2
exa-0.10.1
form_urlencoded-1.0.1
git2-0.13.17
glob-0.3.0
hermit-abi-0.1.18
idna-0.2.2
jobserver-0.1.21
lazy_static-1.4.0
libc-0.2.93
libgit2-sys-0.12.18+1.1.0
libz-sys-1.1.2
locale-0.2.2
log-0.4.14
matches-0.1.8
natord-1.0.9
num_cpus-1.13.0
number_prefix-0.4.0
openssl-src-111.15.0+1.1.1k
openssl-sys-0.9.61
pad-0.1.6
percent-encoding-2.1.0
pkg-config-0.3.19
redox_syscall-0.1.57
scoped_threadpool-0.1.9
term_grid-0.1.7
term_size-0.3.2
tinyvec-1.2.0
tinyvec_macros-0.1.0
unicode-bidi-0.3.5
unicode-normalization-0.1.17
unicode-width-0.1.8
url-2.2.1
users-0.11.0
vcpkg-0.2.11
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
zoneinfo_compiled-0.5.1
${P}
"

inherit bash-completion-r1 cargo

DESCRIPTION="A modern replacement for 'ls' written in Rust"
HOMEPAGE="https://the.exa.website/"
SRC_URI="
	$(cargo_crate_uris ${CRATES})
	https://github.com/ogham/${PN}/releases/download/v${PV}/${PN}-accoutrements-v${PV}.zip
"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="+git bash-completion zsh-completion fish-completion"

DEPEND="git? ( dev-libs/libgit2:= )"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

# some tests fail on tmpfs/zfs/btrfs
RESTRICT="test"

QA_FLAGS_IGNORED="/usr/bin/${PN}"

src_compile() {
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export PKG_CONFIG_ALLOW_CROSS=1
	cargo_src_compile $(usex git "" --no-default-features)
}

src_install() {
	dobin "target/release/${PN}"

	doman "${WORKDIR}/man"/*

	use bash-completion && newbashcomp completions/completions.bash "${PN}"

	use zsh-completion && {
		insinto /usr/share/zsh/site-functions
		newins completions/completions.zsh "_${PN}"
	}

	use fish-completion && {
		insinto /usr/share/fish/vendor_completions.d
		newins completions/completions.fish "${PN}.fish"
	}
}
