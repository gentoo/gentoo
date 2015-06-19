# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/luakit/luakit-2012.09.13_p1-r1.ebuild,v 1.1 2013/07/15 18:22:05 wired Exp $

EAPI=4

inherit toolchain-funcs
IUSE="luajit vim-syntax"

if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/mason-larobina/${PN}.git
		https://github.com/mason-larobina/${PN}.git"
	EGIT_BRANCH="develop"
	KEYWORDS=""
	SRC_URI=""
else
	inherit vcs-snapshot
	MY_PV="${PV/_p/-r}"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/mason-larobina/${PN}/tarball/${MY_PV} -> ${P}.tar.gz"
fi

DESCRIPTION="fast, small, webkit-gtk based micro-browser extensible by lua"
HOMEPAGE="http://mason-larobina.github.com/luakit/"

LICENSE="GPL-3"
SLOT="0"

COMMON_DEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1 )
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libunique:1
	net-libs/libsoup:2.4
	net-libs/webkit-gtk:2
	x11-libs/gtk+:2
"

DEPEND="
	virtual/pkgconfig
	sys-apps/help2man
	${COMMON_DEPEND}
"

RDEPEND="
	${COMMON_DEPEND}
	dev-lua/luafilesystem
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
"

src_prepare() {
	sed -i -e "/^CFLAGS/s/-ggdb//" config.mk || die
}

src_compile() {
	myconf="PREFIX=/usr DEVELOPMENT_PATHS=0"
	if use luajit; then
		myconf+=" USE_LUAJIT=1"
	else
		myconf+=" USE_LUAJIT=0"
	fi

	if [[ ${PV} != *9999* ]]; then
		myconf+=" VERSION=${PV}"
	fi

	tc-export CC
	emake ${myconf}
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" DOCDIR="${D}/usr/share/doc/${PF}" install

	if use vim-syntax; then
		local t
		for t in $(ls "${S}"/extras/vim/); do
			insinto /usr/share/vim/vimfiles/"${t}"
			doins "${S}"/extras/vim/"${t}"/luakit.vim
		done
	fi
}
