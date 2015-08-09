# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit base toolchain-funcs

DESCRIPTION="Libpurple (Pidgin) plug-in supporting microblog services like Twitter or identi.ca"
HOMEPAGE="http://code.google.com/p/microblog-purple/"
MY_P="${P/pidgin-/}"
SRC_URI="http://microblog-purple.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+twitgin"

RDEPEND="net-im/pidgin
	twitgin? ( net-im/pidgin[gtk] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
S=${WORKDIR}/${MY_P}

pkg_setup() {
	tc-export CC
}

src_prepare() {
	# upstream Issue 226 (Respect LDFLAGS)
	sed -i "/^LDFLAGS/d" global.mak || die

	# upstream Issue 225 (Warnings during compilation using make -j2)
	sed -i "s/make /\$(MAKE) /g" Makefile || die

	# upstream Issue 224 (configurable twitgin)
	if ! use twitgin; then
		sed -i 's/twitgin//g' Makefile || die
	fi
}
