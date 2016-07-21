# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit games

DESCRIPTION="Manages renpy symlink"
HOMEPAGE="https://www.gentoo.org/proj/en/eselect/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-eselect/eselect-lib-bin-symlink"

S=${WORKDIR}

pkg_setup() { :; }

src_prepare() {
	sed \
		-e "s#@GAMES_BINDIR@#${GAMES_BINDIR}#" \
		"${FILESDIR}"/renpy.eselect-${PV} > "${WORKDIR}"/renpy.eselect || die
}

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /usr/share/eselect/modules
	doins renpy.eselect
}

pkg_preinst() { :; }

pkg_postinst() { :; }
