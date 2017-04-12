# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="modern, legacy free, simple yet efficient vim-like editor"
HOMEPAGE="https://github.com/martanne/vis"
SRC_URI="https://github.com/martanne/vis/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ncurses selinux tre"

#Note: vis is reported to also work with NetBSD curses
#TODO: >=dev-lang/lua-5.2 (needed for syntax highlighting and settings)
DEPEND=" dev-libs/libtermkey
	ncurses? ( sys-libs/ncurses:0= )
	tre? ( dev-libs/tre:= )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable ncurses curses) \
		$(use_enable selinux) \
		$(use_enable tre)
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
