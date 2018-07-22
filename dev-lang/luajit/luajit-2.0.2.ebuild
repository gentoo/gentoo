# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils multilib pax-utils toolchain-funcs

MY_PV="$(ver_cut 1-3)"
MY_P="LuaJIT-${MY_PV}"

DESCRIPTION="Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="http://luajit.org/"
SRC_URI="http://luajit.org/download/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="2"
KEYWORDS="amd64 arm ~ppc x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/${MY_P}"

HTML_DOCS=( doc/ )
PATCHES=( "${FILESDIR}"/${PN}-luaver.patch
		  "${FILESDIR}"/${PN}-nosymlinks.patch )

src_install(){
	default

	pax-mark m "${ED}usr/bin/luajit-${MY_PV}"
}
