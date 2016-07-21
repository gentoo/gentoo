# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="lightweight, native, lazy evaluating multithreading library"
HOMEPAGE="https://github.com/LuaLanes/lanes"
SRC_URI="https://github.com/LuaLanes/lanes/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

COMMON_DEPEND=">=dev-lang/lua-5.1"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	tc-export CC
	epatch "${FILESDIR}"/${P}-fix-makefile.patch
	sed -i -e "s#/lib#/$(get_libdir)#" Makefile || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc ABOUT BUGS CHANGES README TODO
dohtml -r docs/*
}
