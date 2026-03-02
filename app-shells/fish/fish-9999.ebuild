# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

if [[ ${PV} != 9999 ]]; then
	declare -A GIT_CRATES=(
		[pcre2-sys]='https://github.com/fish-shell/rust-pcre2;85b7afba1a9d9bd445779800e5bcafeb732e4421;rust-pcre2-%commit%/pcre2-sys'
		[pcre2]='https://github.com/fish-shell/rust-pcre2;85b7afba1a9d9bd445779800e5bcafeb732e4421;rust-pcre2-%commit%'
	)
fi

RUST_MIN_VER="1.85.0"

PYTHON_COMPAT=( python3_{11..14} )

inherit cargo cmake python-any-r1 readme.gentoo-r1 xdg

DESCRIPTION="Friendly Interactive SHell"
HOMEPAGE="https://fishshell.com/"

MY_PV="${PV/_beta/b}"
MY_P="${PN}-${MY_PV}"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fish-shell/fish-shell.git"
else
	SRC_URI="
		https://github.com/fish-shell/fish-shell/releases/download/${MY_PV}/${MY_P}.tar.xz
		https://github.com/gentoo-crate-dist/fish-shell/releases/download/${MY_PV}/fish-shell-${MY_PV}-crates.tar.xz
		${CARGO_CRATE_URIS}
	"
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x64-macos"
fi

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2 BSD BSD-2 CC0-1.0 GPL-2+ ISC LGPL-2+ MIT PSF-2 ZLIB"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-3.0 ZLIB"
SLOT="0"
IUSE="+doc nls test"

RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	${PYTHON_USEDEP}
	doc? ( $(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]') )
	nls? ( sys-devel/gettext )
	test? (
		app-misc/tmux
		dev-vcs/git
		sys-apps/less
		$(python_gen_any_dep 'dev-python/pexpect[${PYTHON_USEDEP}]')
	)
"
DEPEND="dev-libs/libpcre2[pcre32]"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/.*"

python_check_deps() {
	if use doc; then
		python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]" || return 1
	fi
	if use test; then
		python_has_version "dev-python/pexpect[${PYTHON_USEDEP}]" || return 1
	fi
}

pkg_setup() {
	if use doc || use test; then
		python-any-r1_pkg_setup
	fi
	rust_pkg_setup

	export PKG_CONFIG_ALLOW_CROSS=1
}

src_prepare() {
	# Bug: https://bugs.gentoo.org/952080
	sed -e '/^lto = /d' -i Cargo.toml || die "Failed to remove LTO from cargo package"

	cmake_src_prepare
}

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DCMAKE_INSTALL_DATADIR="${EPREFIX}/usr/share"
		-DWITH_DOCS="$(usex doc ON OFF)"
		-DWITH_MESSAGE_LOCALIZATION="$(usex nls ON OFF)"
		-DRust_CARGO="${CARGO}"
		-DRust_COMPILER="${RUSTC}"
	)
	local -x CMAKE_BUILD_TYPE="$(usex debug Debug Release)"
	cargo_env cmake_src_configure
}

src_compile() {
	local -x CARGO_TERM_COLOR=always
	cargo_env cmake_src_compile
}

src_test() {
	# Very fragile tests, don't seem to work in sandboxed environment.
	# No die to allow repeating tests.
	rm -v \
		tests/checks/tmux-pager.fish \
		tests/checks/tmux-wrapping.fish \
		tests/checks/tmux-commandline.fish \
		tests/checks/tmux-prompt.fish \
		tests/pexpects/terminal.py \
		|| :

	if [[ ${PV} == 9999 ]]; then
		# https://github.com/fish-shell/fish-shell/issues/12497
		rm -v tests/checks/version.fish || :
	fi

	cargo_env cmake_build fish_run_tests
}

src_install() {
	cargo_env cmake_src_install
	keepdir /usr/share/fish/vendor_{completions,conf,functions}.d
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	xdg_pkg_postinst
}
