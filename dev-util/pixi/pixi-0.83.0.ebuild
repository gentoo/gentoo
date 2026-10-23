# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.97.0"
CRATES="
"

declare -A GIT_CRATES=(
	[version-ranges]='https://github.com/astral-sh/pubgrub;d8efd77673c9a90792da9da31b6c0da7ea8a324b;pubgrub-%commit%/version-ranges'
)

inherit cargo multiprocessing

CRATE_P=${P}
DESCRIPTION="A package management and workflow tool"
HOMEPAGE="
	https://pixi.prefix.dev/
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
	CC0-1.0 CDLA-Permissive-2.0 ISC MIT MPL-2.0 Unicode-3.0 ZLIB BZIP2
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+rustls test"
RESTRICT="test"
PROPERTIES="test? ( test_network )"

RDEPEND="
	app-arch/bzip2:=
	app-arch/xz-utils:=
	app-arch/zstd:=
	sys-apps/dbus
	!rustls? ( dev-libs/openssl:= )
"
BDEPEND="
	test? ( dev-util/cargo-nextest )
"

QA_PREBUILT="usr/bin/pixi"

src_prepare() {
	default

	# replace upstream crate substitution with our crate substitution, sigh
	local pkg
	for pkg in version-ranges; do
		local dep=$(grep "^${pkg}" "${ECARGO_HOME}"/config.toml || die)
		sed -i -e "/\[patch\.crates-io\]/,\$s;^${pkg}.*$;${dep};" Cargo.toml || die
	done

}

src_configure() {
	local myfeatures=(
		$(usex rustls rustls native-tls)
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

	# rattler-build is forcing bundled libdbus
	sed -i -e '/"vendored"/d' -e 's:"crypto-rust":"crypto-openssl":' \
		"${ECARGO_VENDOR}"/rattler_networking-*/Cargo.toml || die
}

src_test() {
	# tests use it to test preserving envvars, apparently assuming
	# it will be always set
	local -x USER=${USER}
	local -x NEXTEST_TEST_THREADS="$(makeopts_jobs)"
	set -- cargo nextest run --verbose --no-fail-fast \
		"${ECARGO_ARGS[@]}" $(usev !debug '--release')
	echo "${@@Q}" >&2
	"${@}" || die "cargo nextest failed"
}

src_install() {
	dobin "$(cargo_target_dir)/pixi"
}
