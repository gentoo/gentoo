# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

# Tests fail when build directory is not inside source directory.
BUILD_DIR="${S}/build"

inherit cargo cmake multiprocessing python-any-r1 readme.gentoo-r1 xdg

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
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2 BSD BSD-2 CC0-1.0 GPL-2+ ISC LGPL-2+ MIT PSF-2 ZLIB"
# Dependent crate licenses
LICENSE+=" MIT Unicode-DFS-2016 WTFPL-2 ZLIB"
SLOT="0"
IUSE="+doc nls test"

RESTRICT="!test? ( test )"

BDEPEND="
	nls? ( sys-devel/gettext )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/pexpect[${PYTHON_USEDEP}]
		')
	)
"
# Release tarballs contain prebuilt documentation.
[[ ${PV} == 9999 ]] && BDEPEND+=" doc? ( dev-python/sphinx )"

PATCHES=(
	"${FILESDIR}/${PN}-9999-use-cargo-eclass-for-build.patch"
)

QA_FLAGS_IGNORED="usr/bin/.*"

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/pexpect[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
	rust_pkg_setup
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
		-DCTEST_PARALLEL_LEVEL=$(makeopts_jobs)
		-DINSTALL_DOCS="$(usex doc)"
	)
	cargo_src_configure --no-default-features \
		--bin fish \
		--bin fish_indent \
		--bin fish_key_reader
	cmake_src_configure
}

src_compile() {
	local -x PREFIX="${EPREFIX}/usr"
	local -x DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
	local -x CMAKE_WITH_GETTEXT="$(usex nls 1 0)"

	# Bug: https://bugs.gentoo.org/950699
	local -x SYSCONFDIR="${EPREFIX}/etc"

	# Release tarballs contain prebuilt documentation.
	local -x FISH_BUILD_DOCS
	if [[ ${PV} == 9999 ]]; then
		FISH_BUILD_DOCS="$(usex doc 1 0)"
	else
		FISH_BUILD_DOCS=0
	fi

	cargo_src_compile
}

src_test() {
	# Tests will create temporary directories.
	local -x TMPDIR="${T}"

	# Otherwise the dimension will be 0x0
	local -x COLUMNS=80
	local -x LINES=24

	# Both depend in locale variables which might not be available.
	# No die to allow repeated test runs.
	rm -v tests/checks/{basic,locale}.fish || :

	# Gets skipped when tmux is missing, but we want consistency across different systems.
	# No die to allow repeated test runs.
	rm -v tests/checks/tmux-*.fish || :

	# Enable colored output for building tests.
	local -x CARGO_TERM_COLOR=always
	cargo_env cmake_build fish_run_tests
}

src_install() {
	cmake_src_install
	keepdir /usr/share/fish/vendor_{completions,conf,functions}.d
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	xdg_pkg_postinst
}
