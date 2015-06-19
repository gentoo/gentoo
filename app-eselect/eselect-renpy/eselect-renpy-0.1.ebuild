# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-renpy/eselect-renpy-0.1.ebuild,v 1.1 2015/03/31 16:55:36 ulm Exp $

EAPI=5

inherit games

DESCRIPTION="Manages renpy symlink"
HOMEPAGE="http://www.gentoo.org/proj/en/eselect/"

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
