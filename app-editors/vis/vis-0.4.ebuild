# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PTV=0.2

DESCRIPTION="modern, legacy free, simple yet efficient vim-like editor"
HOMEPAGE="https://github.com/martanne/vis"
SRC_URI="https://github.com/martanne/vis/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/martanne/vis-test/archive/v${MY_PTV}.tar.gz -> vis-test-${MY_PTV}.tar.gz )"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ncurses selinux test tre"

#Note: vis is reported to also work with NetBSD curses
#TODO: >=dev-lang/lua-5.2 (needed for syntax highlighting and settings)
DEPEND="dev-libs/libtermkey
	ncurses? ( sys-libs/ncurses:0= )
	tre? ( dev-libs/tre:= )"
RDEPEND="${DEPEND}
	app-eselect/eselect-vi"

src_prepare() {
	if use test; then
		rm -r test || die
		mv "${WORKDIR}/vis-test-${MY_PTV}" test || die
		if ! type -P vim &>/dev/null; then
			sed -i 's/.*vim.*//' test/Makefile || die
		fi
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
