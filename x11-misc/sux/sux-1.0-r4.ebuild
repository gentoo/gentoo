# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="\"su\" wrapper which transfers X credentials"
HOMEPAGE="http://fgouget.free.fr/sux/sux-readme.shtml"
SRC_URI="http://fgouget.free.fr/sux/sux"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ppc sparc x86"
IUSE=""

S="${WORKDIR}"

RDEPEND="x11-apps/xauth"

src_unpack() {
	cp "${DISTDIR}"/${A} .
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-r1.patch \
		"${FILESDIR}"/${PN}-X11R6.patch \
		"${FILESDIR}"/${P}-dash.patch
}

src_install() {
	dobin sux
}
