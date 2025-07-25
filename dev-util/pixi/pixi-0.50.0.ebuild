# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

declare -A GIT_CRATES=(
	[async_zip]='https://github.com/charliermarsh/rs-async-zip;c909fda63fcafe4af496a07bfda28a5aae97e58d;rs-async-zip-%commit%'
	[pubgrub]='https://github.com/astral-sh/pubgrub;06ec5a5f59ffaeb6cf5079c6cb184467da06c9db;pubgrub-%commit%'
	[reqwest-middleware]='https://github.com/astral-sh/reqwest-middleware;ad8b9d332d1773fde8b4cd008486de5973e0a3f8;reqwest-middleware-%commit%/reqwest-middleware'
	[reqwest-retry]='https://github.com/astral-sh/reqwest-middleware;ad8b9d332d1773fde8b4cd008486de5973e0a3f8;reqwest-middleware-%commit%/reqwest-retry'
	[tl]='https://github.com/astral-sh/tl;6e25b2ee2513d75385101a8ff9f591ef51f314ec;tl-%commit%'
	[uv-auth]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-auth'
	[uv-build-backend]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-build-backend'
	[uv-build-frontend]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-build-frontend'
	[uv-cache-info]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-cache-info'
	[uv-cache-key]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-cache-key'
	[uv-cache]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-cache'
	[uv-client]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-client'
	[uv-configuration]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-configuration'
	[uv-console]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-console'
	[uv-dirs]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-dirs'
	[uv-dispatch]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-dispatch'
	[uv-distribution-filename]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-distribution-filename'
	[uv-distribution-types]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-distribution-types'
	[uv-distribution]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-distribution'
	[uv-extract]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-extract'
	[uv-fs]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-fs'
	[uv-git-types]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-git-types'
	[uv-git]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-git'
	[uv-globfilter]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-globfilter'
	[uv-install-wheel]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-install-wheel'
	[uv-installer]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-installer'
	[uv-macros]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-macros'
	[uv-metadata]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-metadata'
	[uv-normalize]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-normalize'
	[uv-once-map]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-once-map'
	[uv-options-metadata]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-options-metadata'
	[uv-pep440]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-pep440'
	[uv-pep508]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-pep508'
	[uv-platform-tags]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-platform-tags'
	[uv-pypi-types]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-pypi-types'
	[uv-python]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-python'
	[uv-redacted]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-redacted'
	[uv-requirements-txt]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-requirements-txt'
	[uv-requirements]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-requirements'
	[uv-resolver]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-resolver'
	[uv-shell]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-shell'
	[uv-small-str]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-small-str'
	[uv-state]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-state'
	[uv-static]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-static'
	[uv-torch]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-torch'
	[uv-trampoline-builder]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-trampoline-builder'
	[uv-types]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-types'
	[uv-version]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-version'
	[uv-virtualenv]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-virtualenv'
	[uv-warnings]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-warnings'
	[uv-workspace]='https://github.com/astral-sh/uv;2514203964449fcd3a5cac3320963aa57383e6b6;uv-%commit%/crates/uv-workspace'
	[version-ranges]='https://github.com/astral-sh/pubgrub;06ec5a5f59ffaeb6cf5079c6cb184467da06c9db;pubgrub-%commit%/version-ranges'
)

RUST_MIN_VER="1.85.0"

inherit cargo

CRATE_P=${P}
DESCRIPTION="A package management and workflow tool"
HOMEPAGE="
	https://pixi.sh/
	https://github.com/prefix-dev/pixi/
"
SRC_URI="
	https://github.com/prefix-dev/pixi/releases/download/v${PV}/source.tar.gz
		-> ${P}.tar.gz
	${CARGO_CRATE_URIS}
	https://github.com/gentoo-crate-dist/pixi/releases/download/v${PV}/${P}-crates.tar.xz
"

LICENSE="BSD"
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD Boost-1.0
	CDLA-Permissive-2.0 ISC MIT MPL-2.0 MPL-2.0 Unicode-3.0 ZLIB BZIP2
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+rustls"

RDEPEND="
	app-arch/bzip2:=
	app-arch/xz-utils:=
	app-arch/zstd:=
	!rustls? ( dev-libs/openssl:= )
"

src_prepare() {
	default

	# replace upstream crate substitution with our crate substitution, sigh
	local pkg
	for pkg in reqwest-middleware reqwest-retry version-ranges; do
		local dep=$(grep "^${pkg}" "${ECARGO_HOME}"/config.toml || die)
		sed -i -e "/\[patch\.crates-io\]/,\$s;^${pkg}.*$;${dep};" Cargo.toml || die
	done

}

src_configure() {
	local myfeatures=(
		$(usex rustls rustls-tls native-tls)
	)
	cargo_src_configure --no-default-features

	export ZSTD_SYS_USE_PKG_CONFIG=1

	# bzip2-sys requires a pkg-config file
	# https://github.com/alexcrichton/bzip2-rs/issues/104
	mkdir "${T}/pkg-config" || die
	export PKG_CONFIG_PATH=${T}/pkg-config${PKG_CONFIG_PATH+:${PKG_CONFIG_PATH}}
	cat >> "${T}/pkg-config/bzip2.pc" <<-EOF || die
		Name: bzip2
		Version: 9999
		Description:
		Libs: -lbz2
	EOF
}

src_test() {
	# tests use it to test preserving envvars, apparently assuming
	# it will be always set
	local -x USER=${USER}
	cargo_src_test --no-fail-fast
}
