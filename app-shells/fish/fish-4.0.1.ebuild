# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

declare -A GIT_CRATES=(
	[pcre2-sys]='https://github.com/fish-shell/rust-pcre2;85b7afba1a9d9bd445779800e5bcafeb732e4421;rust-pcre2-%commit%/pcre2-sys'
	[pcre2]='https://github.com/fish-shell/rust-pcre2;85b7afba1a9d9bd445779800e5bcafeb732e4421;rust-pcre2-%commit%'
)

inherit cargo cmake multiprocessing readme.gentoo-r1 xdg

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
"
# Release tarballs contain prebuilt documentation.
[[ ${PV} == 9999 ]] && BDEPEND+=" doc? ( dev-python/sphinx )"

QA_FLAGS_IGNORED="usr/bin/.*"

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
		-DCTEST_PARALLEL_LEVEL="$(makeopts_jobs)"
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

	# Copy built binaries into the cmake build directory to mark the targets
	# up-to-date in cmake.
	for target in fish fish_indent fish_key_reader; do
		cp "$(cargo_target_dir)/${target}" "${BUILD_DIR}" || die
	done

	cmake_src_compile
}

src_test() {
	local -x CARGO_TERM_COLOR=always
	local -x FISH_SOURCE_DIR="${S}"
	local -x FISH_FORCE_COLOR=1
	local -x TEST_VERBOSE=1
	cargo_env cmake_src_test -R cargo-test
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
