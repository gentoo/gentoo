# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3

DESCRIPTION="modern, legacy free, simple yet efficient vim-like editor"
HOMEPAGE="https://github.com/martanne/vis"
EGIT_REPO_URI="https://github.com/martanne/vis.git"
LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="+ncurses selinux test tre"
RESTRICT="!test? ( test )"

#Note: vis is reported to also work with NetBSD curses
#TODO: >=dev-lang/lua-5.2 (needed for syntax highlighting and settings)
DEPEND="dev-libs/libtermkey
	ncurses? ( sys-libs/ncurses:0= )
	tre? ( dev-libs/tre:= )"
RDEPEND="${DEPEND}
	app-eselect/eselect-vi"

src_prepare() {
	if use test && ! type -P vim &>/dev/null; then
		sed -i 's/.*vim.*//' "${S}/test/Makefile" || die
	fi

	sed -i 's|STRIP?=.*|STRIP=true|' Makefile || die
	sed -i 's|${DOCPREFIX}/vis|${DOCPREFIX}|' Makefile || die
	sed -i 's|DOCUMENTATION = LICENSE|DOCUMENTATION =|' Makefile || die

	default
}

src_configure() {
	./configure \
		--prefix="${EROOT}usr" \
		--docdir="${EROOT}usr/share/doc/${PF}" \
		$(use_enable ncurses curses) \
		$(use_enable selinux) \
		$(use_enable tre) || die
}

update_symlinks() {
	einfo "Calling eselect vi update --if-unset…"
	eselect vi update --if-unset
}

pkg_postrm() {
	update_symlinks
}

pkg_postinst() {
	update_symlinks
}
