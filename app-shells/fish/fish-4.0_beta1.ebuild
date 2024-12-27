# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	allocator-api2@0.2.18
	autocfg@1.4.0
	bitflags@2.6.0
	block-buffer@0.10.4
	cc@1.1.30
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	cpufeatures@0.2.14
	crypto-common@0.1.6
	dashmap@5.5.3
	digest@0.10.7
	equivalent@1.0.1
	errno@0.3.9
	fnv@1.0.7
	foldhash@0.1.3
	generic-array@0.14.7
	hashbrown@0.14.5
	hashbrown@0.15.0
	jobserver@0.1.32
	lazy_static@1.5.0
	libc@0.2.159
	lock_api@0.4.12
	log@0.4.22
	lru@0.12.5
	memchr@2.7.4
	minimal-lexical@0.2.1
	nix@0.29.0
	nom@7.1.3
	num-traits@0.2.19
	once_cell@1.20.2
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	phf@0.11.2
	phf_codegen@0.11.2
	phf_generator@0.11.2
	phf_shared@0.11.2
	pkg-config@0.3.31
	portable-atomic@1.9.0
	proc-macro2@1.0.87
	quote@1.0.37
	rand@0.8.5
	rand_core@0.6.4
	redox_syscall@0.5.7
	rsconf@0.2.2
	rust-embed-impl@8.5.0
	rust-embed-utils@8.5.0
	rust-embed@8.5.0
	same-file@1.0.6
	scopeguard@1.2.0
	serial_test@1.0.0
	serial_test_derive@1.0.0
	sha2@0.10.8
	shlex@1.3.0
	siphasher@0.3.11
	smallvec@1.13.2
	syn@1.0.109
	syn@2.0.79
	terminfo@0.9.0
	typenum@1.17.0
	unicode-ident@1.0.13
	version_check@0.9.5
	walkdir@2.5.0
	widestring@1.1.0
	winapi-util@0.1.9
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
"

declare -A GIT_CRATES=(
	[pcre2-sys]='https://github.com/fish-shell/rust-pcre2;85b7afba1a9d9bd445779800e5bcafeb732e4421;rust-pcre2-%commit%/pcre2-sys'
	[pcre2]='https://github.com/fish-shell/rust-pcre2;85b7afba1a9d9bd445779800e5bcafeb732e4421;rust-pcre2-%commit%'
)

PYTHON_COMPAT=( python3_{10..13} )

inherit cargo cmake python-any-r1 readme.gentoo-r1 xdg

DESCRIPTION="Friendly Interactive SHell"
HOMEPAGE="https://fishshell.com/"

MY_PV="${PV/_beta/b}"
MY_P="${PN}-${MY_PV}"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fish-shell/fish-shell.git"
else
	SRC_URI="
		https://github.com/fish-shell/fish-shell/releases/download/${MY_PV}/${MY_P}.tar.xz
		${CARGO_CRATE_URIS}
	"
	# KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2 BSD BSD-2 CC0-1.0 GPL-2+ ISC LGPL-2+ MIT PSF-2 ZLIB"
# Dependent crate licenses
LICENSE+=" MIT Unicode-DFS-2016 WTFPL-2 ZLIB"
SLOT="0"
IUSE="+doc nls split-usr test"

RESTRICT="!test? ( test )"

BDEPEND="
	nls? ( sys-devel/gettext )
	test? (
		${PYTHON_DEPS}
		dev-tcltk/expect
		$(python_gen_any_dep '
			dev-python/pexpect[${PYTHON_USEDEP}]
		')
	)
"
# we don't need shpinx dep for release tarballs
[[ ${PV} == 9999 ]] && BDEPEND+=" doc? ( dev-python/sphinx )"

QA_FLAGS_IGNORED="**bin/fish*"

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

src_prepare() {
	# workaround for https://github.com/fish-shell/fish-shell/issues/4883
	if use split-usr; then
		sed -i 's#${TEST_INSTALL_DIR}/${CMAKE_INSTALL_PREFIX}#${TEST_INSTALL_DIR}#' \
			cmake/Tests.cmake || die
	fi

	# remove the build targets from the default build set so they are not wanted
	# if cmake_src_install is called
	sed -i \
		-e '
		/function(CREATE_TARGET target)/,/endfunction(CREATE_TARGET)/ {
			s/${target} ALL/${target}/
		}' CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# installing into /bin breaks tests on merged usr systems.
		# sbin -> bin symlink confuses tests.
		# so on split-usr we install to /bin.
		# on merge-usr we set sbindir to bin.
		$(usex split-usr "-DCMAKE_INSTALL_BINDIR=${EPREFIX}/bin" \
			"-DCMAKE_INSTALL_SBINDIR=${EPREFIX}/usr/bin")
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DINSTALL_DOCS="$(usex doc)"
		-DWITH_GETTEXT="$(usex nls)"
	)
	# release tarballs ship pre-built docs // -DHAVE_PREBUILT_DOCS=TRUE
	if [[ ${PV} == 9999 ]]; then
		mycmakeargs+=( -DBUILD_DOCS="$(usex doc)" )
	else
		mycmakeargs+=( -DBUILD_DOCS=OFF )
	fi
	cargo_src_configure --no-default-features --bin fish --bin fish_indent --bin fish_key_reader
	cmake_src_configure
}

src_compile() {
	local -x PREFIX="${EPREFIX}/usr"
	local -x DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
	local -x CMAKE_WITH_GETTEXT
	CMAKE_WITH_GETTEXT="$(usex nls 1 0)"
	cargo_src_compile

	for target in fish fish_indent fish_key_reader; do
		cp "$(cargo_target_dir)/${target}" "${BUILD_DIR}" || die
	done
	cmake_src_compile
}

src_install() {
	cmake_src_install
	keepdir /usr/share/fish/vendor_{completions,conf,functions}.d
	readme.gentoo_create_doc
}

src_test() {
	# tests will create temporary files
	local -x TMPDIR="${T}"

	# some tests are fragile, sanitize environment
	local -x COLUMNS=80
	local -x LINES=24

	# very fragile, depends on terminal, size, tmux, screen and timing
	# no die is intentional, for repeated test runs
	if [[ ${PV} != 9999 ]]; then
		rm -v tests/pexpects/terminal.py || :
	fi

	# TODO: fix tests & submit upstream
	# tests are confused by usr/sbin -> bin symlink, no die is intentional for repeated test runs
	use split-usr || rm -v tests/checks/{redirect,type}.fish || :

	# tests are invoked through the test target
	cargo_env cmake_build test
}

pkg_postinst() {
	readme.gentoo_print_elog
	xdg_pkg_postinst
}
