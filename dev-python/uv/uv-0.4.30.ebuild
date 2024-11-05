# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

declare -A GIT_CRATES=(
	[async_zip]='https://github.com/charliermarsh/rs-async-zip;011b24604fa7bc223daaad7712c0694bac8f0a87;rs-async-zip-%commit%'
	[pubgrub]='https://github.com/astral-sh/pubgrub;95e1390399cdddee986b658be19587eb1fdb2d79;pubgrub-%commit%'
	[reqwest-middleware]='https://github.com/TrueLayer/reqwest-middleware;d95ec5a99fcc9a4339e1850d40378bbfe55ab121;reqwest-middleware-%commit%/reqwest-middleware'
	[reqwest-retry]='https://github.com/TrueLayer/reqwest-middleware;d95ec5a99fcc9a4339e1850d40378bbfe55ab121;reqwest-middleware-%commit%/reqwest-retry'
	[tl]='https://github.com/charliermarsh/tl;6e25b2ee2513d75385101a8ff9f591ef51f314ec;tl-%commit%'
	[version-ranges]='https://github.com/astral-sh/pubgrub;95e1390399cdddee986b658be19587eb1fdb2d79;pubgrub-%commit%/version-ranges'
)

inherit cargo check-reqs

CRATE_PV=${PV}
DESCRIPTION="A Python package installer and resolver, written in Rust"
HOMEPAGE="
	https://github.com/astral-sh/uv/
	https://pypi.org/project/uv/
"
# pypi sdist misses scripts/, needed for tests
SRC_URI="
	https://github.com/astral-sh/uv/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://dev.gentoo.org/~mgorny/dist/uv-${CRATE_PV}-crates.tar.xz
	"
fi

# most of the code
LICENSE="|| ( Apache-2.0 MIT )"
# crates/pep508-rs is || ( Apache-2.0 BSD-2 ) which is covered below
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD ISC MIT
	MPL-2.0 Unicode-DFS-2016
"
# ring crate
LICENSE+=" openssl"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="test"
PROPERTIES="test_network"

DEPEND="
	app-arch/bzip2:=
	app-arch/xz-utils:=
	app-arch/zstd:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=virtual/rust-1.80
	test? (
		dev-lang/python:3.8
		dev-lang/python:3.9
		dev-lang/python:3.10
		dev-lang/python:3.11
		dev-lang/python:3.12
	)
"

QA_FLAGS_IGNORED="usr/bin/.*"

check_space() {
	local CHECKREQS_DISK_BUILD=3G
	use debug && CHECKREQS_DISK_BUILD=9G
	check-reqs_pkg_setup
}

pkg_pretend() {
	check_space
}

pkg_setup() {
	check_space
}

src_prepare() {
	default

	# remove patch.* that breaks GIT_CRATES
	local reqmw=${GIT_CRATES[reqwest-middleware]}
	reqmw=${reqmw#*;}
	reqmw=${reqmw%;*}
	sed -i -e "/^\[patch/,\$s@^\(reqwest-middleware = \).*@\1 { path = \"${WORKDIR}/reqwest-middleware-${reqmw}/reqwest-middleware\" }@" Cargo.toml || die

	# enable system libraries where supported
	export ZSTD_SYS_USE_PKG_CONFIG=1
	# TODO: unbundle libz-ng-sys, tikv-jemalloc-sys?

	# remove unbundled sources, just in case
	find "${ECARGO_VENDOR}"/{bzip2,lzma,zstd}-sys-*/ -name '*.c' -delete || die

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

src_configure() {
	local myfeatures=(
		git
		pypi
		python
	)

	cargo_src_configure --no-default-features
}

src_compile() {
	cd crates/uv || die
	cargo_src_compile
}

src_test() {
	# work around https://github.com/astral-sh/uv/issues/4376
	local -x PATH=${BROOT}/usr/lib/python-exec/python3.12:${PATH}
	local -x COLUMNS=100
	local -x PYTHONDONTWRITEBYTECODE=

	cd crates/uv || die
	cargo_src_test --no-fail-fast
}

src_install() {
	cd crates/uv || die
	cargo_src_install
}
