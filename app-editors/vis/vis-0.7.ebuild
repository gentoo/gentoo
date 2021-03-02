# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PTV=0.5
LUA_COMPAT=( lua5-2 lua5-3 )

inherit lua-single optfeature

DESCRIPTION="modern, legacy free, simple yet efficient vim-like editor"
HOMEPAGE="https://github.com/martanne/vis"
SRC_URI="https://github.com/martanne/vis/releases/download/v${PV}/${P}.tar.gz
	test? ( https://github.com/martanne/vis-test/releases/download/v${MY_PTV}/vis-test-${MY_PTV}.tar.gz )"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm x86"
IUSE="+ncurses +lua selinux test tre"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

# - Known to also work with NetBSD curses
DEPEND="dev-libs/libtermkey
	ncurses? ( sys-libs/ncurses:0= )
	lua? ( ${LUA_DEPS} )
	tre? ( dev-libs/tre:= )"
RDEPEND="${DEPEND}
	app-eselect/eselect-vi"
# https://github.com/martanne/vis-test/issues/28
BDEPEND="test? ( $(lua_gen_cond_dep 'dev-lua/lpeg[${LUA_USEDEP}]') )"

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	if use test; then
		rm -r test || die
		mv "${WORKDIR}/vis-test-${MY_PTV}" test || die

		# https://bugs.gentoo.org/722014 https://github.com/martanne/vis-test/pull/22
		sed -i 's;./ccan-config > config.h;./ccan-config "${CC}" ${CFLAGS} > config.h;' test/core/Makefile || die

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
	optfeature "syntax highlighting support" dev-lua/lpeg
}
