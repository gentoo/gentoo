# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ansi_term@0.12.1
	autocfg@1.0.1
	bitflags@1.2.1
	byteorder@1.4.3
	cc@1.0.67
	cfg-if@1.0.0
	datetime@0.5.2
	form_urlencoded@1.0.1
	git2@0.13.17
	glob@0.3.0
	hermit-abi@0.1.18
	idna@0.2.2
	jobserver@0.1.21
	lazy_static@1.4.0
	libc@0.2.93
	libgit2-sys@0.12.18+1.1.0
	libz-sys@1.1.2
	locale@0.2.2
	log@0.4.14
	matches@0.1.8
	natord@1.0.9
	num_cpus@1.13.0
	number_prefix@0.4.0
	openssl-src@111.15.0+1.1.1k
	openssl-sys@0.9.61
	pad@0.1.6
	percent-encoding@2.1.0
	pkg-config@0.3.19
	redox_syscall@0.1.57
	scoped_threadpool@0.1.9
	term_grid@0.1.7
	term_size@0.3.2
	tinyvec@1.2.0
	tinyvec_macros@0.1.0
	unicode-bidi@0.3.5
	unicode-normalization@0.1.17
	unicode-width@0.1.8
	url@2.2.1
	users@0.11.0
	vcpkg@0.2.11
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	zoneinfo_compiled@0.5.1
"

inherit shell-completion cargo

DESCRIPTION="A modern replacement for 'ls' written in Rust"
HOMEPAGE="https://the.exa.website/"
SRC_URI="https://github.com/ogham/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+git man"

DEPEND="git? ( dev-libs/libgit2:= )"
RDEPEND="${DEPEND}"
BDEPEND+="man? ( virtual/pandoc )"

QA_FLAGS_IGNORED="usr/bin/exa"

src_prepare() {
	default
	if use man; then
		mkdir -p contrib/man || die "failed to create man directory"
		pandoc --standalone -f markdown -t man man/exa_colors.5.md \
			-o contrib/man/exa_colors.5 || die "failed to create colored man pages"
		pandoc --standalone -f markdown -t man man/exa.1.md -o \
			contrib/man/exa.1 || die "failed to create man pages"
	fi

	# "source" files only, but cargo.eclass will attempt to install them.
	rm -r man || die "failed to remove man directory from source"
}

src_compile() {
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export PKG_CONFIG_ALLOW_CROSS=1
	local myfeatures=(
		$(usev git)
	)
	cargo_src_compile --no-default-features
}

src_install() {
	cargo_src_install $(usex git "" --no-default-features)

	newbashcomp completions/completions.bash exa
	newzshcomp completions/completions.zsh _exa
	newfishcomp completions/completions.fish exa.fish

	if use man; then
		doman contrib/man/*
	fi
}
