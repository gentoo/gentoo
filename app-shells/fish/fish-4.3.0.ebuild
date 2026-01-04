# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
RUST_MIN_VER="1.85.0"

declare -A GIT_CRATES=(
	[pcre2-sys]='https://github.com/fish-shell/rust-pcre2;85b7afba1a9d9bd445779800e5bcafeb732e4421;rust-pcre2-%commit%/pcre2-sys'
	[pcre2]='https://github.com/fish-shell/rust-pcre2;85b7afba1a9d9bd445779800e5bcafeb732e4421;rust-pcre2-%commit%'
)

inherit cargo cmake readme.gentoo-r1 xdg

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
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-3.0 WTFPL-2 ZLIB"
SLOT="0"
IUSE="+doc nls test"

RESTRICT="!test? ( test )"

BDEPEND="
	doc? ( dev-python/sphinx )
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}/${PN}-4.3.0-use-cargo-eclass-for-build.patch"
)

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
		-DWITH_DOCS="$(usex doc)"
		-DWITH_GETTEXT="$(usex nls 1 0)"
	)
	cargo_src_configure --no-default-features \
		--bin fish \
		--bin fish_indent \
		--bin fish_key_reader
	cmake_src_configure
}

src_compile() {
	local -x PREFIX="${EPREFIX}/usr"
	local -x DATADIR="${EPREFIX}/usr/share"
	local -x DOCDIR="${EPREFIX}/usr/share/doc/${PF}"

	# Bug: https://bugs.gentoo.org/950699
	local -x SYSCONFDIR="${EPREFIX}/etc"

	local -x FISH_BUILD_DOCS
	FISH_BUILD_DOCS="$(usex doc 1 0)"

	cargo_src_compile
}

src_test() {
	local -x CARGO_TERM_COLOR=always
	local -x TEST_VERBOSE=1
	# cargo_env cmake_src_compile fish_run_tests
	cargo_env cmake_src_test fish_run_tests
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
