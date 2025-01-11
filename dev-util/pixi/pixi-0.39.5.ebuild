# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

declare -A GIT_CRATES=(
	[async_zip]='https://github.com/charliermarsh/rs-async-zip;c909fda63fcafe4af496a07bfda28a5aae97e58d;rs-async-zip-%commit%'
	[pubgrub]='https://github.com/astral-sh/pubgrub;57832d0588fbb7aab824813481104761dc1c7740;pubgrub-%commit%'
	[tl]='https://github.com/astral-sh/tl;6e25b2ee2513d75385101a8ff9f591ef51f314ec;tl-%commit%'
	[uv-auth]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-auth'
	[uv-build-frontend]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-build-frontend'
	[uv-cache-info]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-cache-info'
	[uv-cache-key]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-cache-key'
	[uv-cache]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-cache'
	[uv-client]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-client'
	[uv-configuration]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-configuration'
	[uv-console]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-console'
	[uv-dirs]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-dirs'
	[uv-dispatch]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-dispatch'
	[uv-distribution-filename]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-distribution-filename'
	[uv-distribution-types]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-distribution-types'
	[uv-distribution]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-distribution'
	[uv-extract]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-extract'
	[uv-fs]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-fs'
	[uv-git]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-git'
	[uv-install-wheel]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-install-wheel'
	[uv-installer]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-installer'
	[uv-macros]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-macros'
	[uv-metadata]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-metadata'
	[uv-normalize]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-normalize'
	[uv-once-map]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-once-map'
	[uv-options-metadata]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-options-metadata'
	[uv-pep440]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-pep440'
	[uv-pep508]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-pep508'
	[uv-platform-tags]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-platform-tags'
	[uv-pypi-types]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-pypi-types'
	[uv-python]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-python'
	[uv-requirements-txt]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-requirements-txt'
	[uv-requirements]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-requirements'
	[uv-resolver]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-resolver'
	[uv-shell]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-shell'
	[uv-state]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-state'
	[uv-static]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-static'
	[uv-trampoline-builder]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-trampoline-builder'
	[uv-types]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-types'
	[uv-version]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-version'
	[uv-virtualenv]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-virtualenv'
	[uv-warnings]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-warnings'
	[uv-workspace]='https://github.com/wolfv/uv;878234ba6b9a3b143e079ca9baa4bec99af93600;uv-%commit%/crates/uv-workspace'
	[version-ranges]='https://github.com/astral-sh/pubgrub;57832d0588fbb7aab824813481104761dc1c7740;pubgrub-%commit%/version-ranges'
)

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
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://dev.gentoo.org/~mgorny/dist/${CRATE_P}-crates.tar.xz
	"
fi

LICENSE="BSD"
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD Boost-1.0
	ISC MIT MPL-2.0 MPL-2.0 Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-arch/bzip2:=
	app-arch/xz-utils:=
	app-arch/zstd:=
	dev-libs/openssl:=
"

PATCHES=(
	# https://github.com/prefix-dev/pixi/pull/2881
	"${FILESDIR}/${P}-offline-tests.patch"
)

src_configure() {
	local myfeatures=(
		native-tls
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
