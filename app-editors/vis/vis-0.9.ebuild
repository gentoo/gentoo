# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VIS_TEST_COMMIT="783b7ef67aa360f0b9bd44fa5ea47e644bc49d69"
LUA_COMPAT=( lua5-2 lua5-3 lua5-4 )

inherit lua-single

if [ "${PV}" == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/martanne/vis.git"
else
	SRC_URI="
		https://github.com/martanne/vis/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		test? ( https://github.com/martanne/vis-test/archive/${VIS_TEST_COMMIT}.tar.gz -> vis-test-${VIS_TEST_COMMIT}.tar.gz )
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

DESCRIPTION="modern, legacy free, simple yet efficient vim-like editor"
HOMEPAGE="https://github.com/martanne/vis"
LICENSE="ISC MIT"
SLOT="0"
IUSE="+ncurses +lua selinux test tre"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

# - Known to also work with NetBSD curses
DEPEND="
	dev-libs/libtermkey
	sys-apps/acl
	ncurses? ( sys-libs/ncurses:0= )
	lua? ( ${LUA_DEPS} )
	tre? ( dev-libs/tre )
"
RDEPEND="
	${DEPEND}
	app-eselect/eselect-vi
	lua? (
		$(lua_gen_cond_dep 'dev-lua/lpeg[${LUA_USEDEP}]')
	)
"
# lpeg: https://github.com/martanne/vis-test/issues/28
BDEPEND="test? (
	$(lua_gen_cond_dep 'dev-lua/lpeg[${LUA_USEDEP}]')
	$(lua_gen_cond_dep 'dev-lua/busted[${LUA_USEDEP}]')
)"

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	if use test; then
		if [ ! "${PV}" == "9999" ]; then
			rm -r test || die
			mv "${WORKDIR}/vis-test-${VIS_TEST_COMMIT}" test || die
		fi

		# https://github.com/martanne/vis-test/issues/27 a Werror clone
		sed -i 's;|| strstr(output, "warning");;' test/core/ccan-config.c || die
	fi

	sed -i 's|STRIP?=.*|STRIP=true|' Makefile || die
	sed -i 's|${DOCPREFIX}/vis|${DOCPREFIX}|' Makefile || die
	sed -i 's|DOCUMENTATION = LICENSE|DOCUMENTATION =|' Makefile || die

	default
}

src_configure() {
	./configure \
		--prefix="${EPREFIX}"/usr \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--disable-lpeg-static \
		$(use_enable lua) \
		$(use_enable ncurses curses) \
		$(use_enable selinux) \
		$(use_enable tre) || die
}

update_symlinks() {
	einfo "Calling eselect vi update --if-unset"
	eselect vi update --if-unset
}

pkg_postrm() {
	update_symlinks
}

pkg_postinst() {
	update_symlinks
}
