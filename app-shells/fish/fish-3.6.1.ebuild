# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake python-any-r1 readme.gentoo-r1 xdg

DESCRIPTION="Friendly Interactive SHell"
HOMEPAGE="https://fishshell.com/"

MY_PV="${PV/_beta/b}"
MY_P="${PN}-${MY_PV}"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}-shell/${PN}-shell.git"
else
	SRC_URI="https://github.com/${PN}-shell/${PN}-shell/releases/download/${MY_PV}/${MY_P}.tar.xz"
	KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+doc nls split-usr test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libpcre2-10.32:=[pcre32]
	sys-apps/coreutils
	sys-libs/ncurses:=[unicode(+)]
"

DEPEND="${RDEPEND}"
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
[[ ${PV} == 9999 ]] && DEPEND+=" doc? ( dev-python/sphinx )"

S="${WORKDIR}/${MY_P}"

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/pexpect[${PYTHON_USEDEP}]"
}

src_prepare() {
	# workaround for https://github.com/fish-shell/fish-shell/issues/4883
	if use split-usr; then
		sed -i 's#${TEST_INSTALL_DIR}/${CMAKE_INSTALL_PREFIX}#${TEST_INSTALL_DIR}#' \
			cmake/Tests.cmake || die
	fi
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
		-DCURSES_NEED_NCURSES=ON
		-DINSTALL_DOCS="$(usex doc)"
		-DWITH_GETTEXT="$(usex nls)"
	)
	# release tarballs ship pre-built docs // -DHAVE_PREBUILT_DOCS=TRUE
	if [[ ${PV} == 9999 ]]; then
		mycmakeargs+=( -DBUILD_DOCS="$(usex doc)" )
	else
		mycmakeargs+=( -DBUILD_DOCS=OFF )
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	keepdir /usr/share/fish/vendor_{completions,conf,functions}.d
	readme.gentoo_create_doc
}

src_test() {
	# some tests are fragile, sanitize environment
	local -x COLUMNS=80
	local -x LINES=24

	# very fragile, depends on terminal, size, tmux, screen and timing
	# no die is intentional, for repeated test runs
	if [[ ${PV} != 9999 ]]; then
		rm -v tests/pexpects/terminal.py || :
	fi

	# zfs completion test will fail with "Permission denied the ZFS utilities must be run as root."
	mv "${S}"/share/completions/zfs.{fish,disabled} || die

	# TODO: fix tests & submit upstream
	# tests are confused by usr/sbin -> bin symlink, no die is intentional for repeated test runs
	use split-usr || rm -v tests/checks/{redirect,type}.fish || :

	cmake_build test

	# now restore zfs completions
	mv "${S}"/share/completions/zfs.{disabled,fish} || die
}

pkg_postinst() {
	readme.gentoo_print_elog
	xdg_pkg_postinst
}
