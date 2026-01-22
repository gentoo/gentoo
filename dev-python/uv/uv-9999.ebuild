# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.90.0"

inherit cargo check-reqs git-r3

DESCRIPTION="A Python package installer and resolver, written in Rust"
HOMEPAGE="
	https://github.com/astral-sh/uv/
	https://pypi.org/project/uv/
"
EGIT_REPO_URI="https://github.com/astral-sh/uv.git"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
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
	virtual/pkgconfig
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

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_prepare() {
	default

	# force thin lto, makes build much faster and less memory hungry
	# (i.e. makes it possible to actually build uv on 32-bit PPC)
	sed -i -e '/lto/s:fat:thin:' Cargo.toml || die

	# enable system libraries where supported
	export ZSTD_SYS_USE_PKG_CONFIG=1
	# TODO: unbundle libz-ng-sys, tikv-jemalloc-sys?

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
