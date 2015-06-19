# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsamixergui/alsamixergui-0.9.0.1.2-r4.ebuild,v 1.21 2013/02/27 07:51:23 vapier Exp $

EAPI=4
inherit autotools eutils flag-o-matic

MY_P=${PN}-0.9.0rc1-2

DESCRIPTION="FLTK based amixer Frontend"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 sparc x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	media-sound/alsa-utils
	x11-libs/fltk:1"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc34.patch \
		"${FILESDIR}"/segfault-on-exit.patch \
		"${FILESDIR}"/${P}-fltk-1.1.patch

	eautoreconf
}

src_configure() {
	append-ldflags "-L$(dirname $(fltk-config --libs))"
	append-flags "-I/usr/include/fltk-1"
	econf
}

src_install() {
	default
	newicon src/images/alsalogo.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Alsa Mixer GUI"
}
