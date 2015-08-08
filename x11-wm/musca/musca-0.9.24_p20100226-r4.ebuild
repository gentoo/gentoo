# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils savedconfig toolchain-funcs

DESCRIPTION="A simple dynamic window manager for X, with features nicked from
ratpoison and dwm"
HOMEPAGE="https://launchpad.net/musca"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="apis xlisten"

COMMON="x11-libs/libX11"
DEPEND="${COMMON}
	sys-apps/sed"
RDEPEND="
	${COMMON}
	>=x11-misc/dmenu-4.4
	apis? ( x11-misc/xbindkeys )
"

src_prepare() {
	restore_config config.h

	sed -i config.h \
		-e 's:"sort | dmenu -i -b":"-i -b":g' \
		-e 's:sed.*exec.*-i::g' \
		|| die

	epatch \
		"${FILESDIR}"/${PN}-0.9.24-make.patch \
		"${FILESDIR}"/${PN}-0.9.24_p20100226-dmenu-4.4.patch \
		"${FILESDIR}"/${PN}-0.9.24_p20100226-null.patch \
		"${FILESDIR}"/${PN}-0.9.24_p20100226-fix-cycle.patch \
		"${FILESDIR}"/${PN}-0.9.24_p20100226-fix-pad.patch

	local i
	for i in apis xlisten; do
		if ! use ${i}; then
			sed -e "s|${i}||g" -i Makefile || die
		fi
	done

	tc-export CC
}

src_install() {
	dobin musca

	local i
	for i in xlisten apis; do
		if use ${i}; then
			dobin ${i}
		fi
	done
	doman musca.1

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}.xsession musca

	save_config config.h
}
