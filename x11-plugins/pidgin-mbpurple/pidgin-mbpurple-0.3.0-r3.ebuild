# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${P/pidgin-/}"

DESCRIPTION="Pidgin plug-in supporting microblog services like Twitter or identi.ca"
HOMEPAGE="https://code.google.com/archive/p/microblog-purple/"
SRC_URI="https://microblog-purple.googlecode.com/files/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="+twitgin"

RDEPEND="net-im/pidgin
	twitgin? ( net-im/pidgin[gtk] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# upstream Issue 226 (Respect LDFLAGS)
	sed -i "/^LDFLAGS/d" global.mak || die "sed for LDFLAGS failed"

	# upstream Issue 225 (Warnings during compilation using make -j2)
	sed -i "s/make /\$(MAKE) /g" Makefile || die "sed #2 failed"

	# upstream Issue 224 (configurable twitgin)
	if ! use twitgin; then
		sed -i 's/twitgin//g' Makefile || die
	fi
}

src_configure() {
	tc-export CC
}
