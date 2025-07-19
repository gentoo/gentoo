# Copyright 2024-2025 Gentoo Authors
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
	[version-ranges]='https://github.com/astral-sh/pubgrub;06ec5a5f59ffaeb6cf5079c6cb184467da06c9db;pubgrub-%commit%/version-ranges'
)

RUST_MIN_VER="1.85.0"

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
		https://github.com/gentoo-crate-dist/uv/releases/download/${CRATE_PV}/uv-${CRATE_PV}-crates.tar.xz
	"
fi

# most of the code
LICENSE="|| ( Apache-2.0 MIT )"
# crates/pep508-rs is || ( Apache-2.0 BSD-2 ) which is covered below
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD Boost-1.0
	ISC MIT MPL-2.0 Unicode-3.0 Unicode-DFS-2016 ZLIB
"
# ring crate
LICENSE+=" openssl"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ppc ppc64 ~riscv ~x86"
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
	test? (
		dev-lang/python:3.9
		dev-lang/python:3.10
		dev-lang/python:3.11
		dev-lang/python:3.12
		dev-lang/python:3.13
		!!~dev-python/uv-0.5.0
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
	rust_pkg_setup
}

src_prepare() {
	default

	# replace upstream crate substitution with our crate substitution, sigh
	local pkg
	for pkg in reqwest-middleware reqwest-retry; do
		local dep=$(grep "^${pkg}" "${ECARGO_HOME}"/config.toml || die)
		sed -i -e "/\[patch\.crates-io\]/,\$s;^${pkg}.*$;${dep};" Cargo.toml || die
	done

	# force thin lto, makes build much faster and less memory hungry
	# (i.e. makes it possible to actually build uv on 32-bit PPC)
	sed -i -e '/lto/s:fat:thin:' Cargo.toml || die

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
	# fix tests failing because of our config
	local -x XDG_CONFIG_DIRS=${T}

	cd crates/uv || die
	cargo_src_test --no-fail-fast
}

src_install() {
	cd crates/uv || die
	cargo_src_install

	insinto /etc/xdg/uv
	newins - uv.toml <<-EOF || die
		# These defaults match Fedora, see:
		# https://src.fedoraproject.org/rpms/uv/pull-request/18

		# By default ("automatic"), uv downloads missing Python versions
		# automatically and keeps them in the user's home directory.
		# Disable that to make downloading opt-in, and especially
		# to avoid unnecessarily fetching custom Python when the distro
		# package would be preferable.  Python builds can still be
		# downloaded manually via "uv python install".
		#
		# https://docs.astral.sh/uv/reference/settings/#python-downloads
		python-downloads = "manual"

		# By default ("managed"), uv always prefers self-installed
		# Python versions over the system Python, independently
		# of versions.  Since we generally expect users to use that
		# to install old Python versions not in ::gentoo anymore,
		# this effectively means that uv would end up preferring very
		# old Python versions over the newer ones that are provided
		# by the system.  Default to using the system versions to avoid
		# this counter-intuitive behavior.
		#
		# https://docs.astral.sh/uv/reference/settings/#python-preference
		python-preference = "system"
	EOF
}
