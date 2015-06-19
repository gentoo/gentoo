# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/worker/worker-2.19.6.ebuild,v 1.7 2013/04/25 19:15:53 pinkbyte Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Worker Filemanager: Amiga Directory Opus 4 clone"
HOMEPAGE="http://www.boomerangsworld.de/cms/worker/"
SRC_URI="http://www.boomerangsworld.de/cms/worker/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ~ppc64 x86"
IUSE="avfs debug dbus examples libnotify +magic xinerama xft"

RDEPEND="x11-libs/libSM
	x11-libs/libX11
	avfs? ( >=sys-fs/avfs-0.9.5 )
	dbus? (	dev-libs/dbus-glib )
	magic? ( sys-apps/file )
	xft? ( x11-libs/libXft )
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog INSTALL NEWS README README_LARGEFILES THANKS )

src_prepare() {
	# respect AR, bug #466014
	sed -i -e "/AR/s/ar/$(tc-getAR)/" src/aguix/Makefile.in || die 'sed on Makefile.in failed'

	epatch_user
}

src_configure() {
	# there is no option for disabling libXinerama support
	use xinerama || export ac_cv_lib_Xinerama_XineramaQueryScreens=no
	econf \
		--without-hal \
		$(use_with avfs) \
		$(use_with dbus) \
		$(use_enable debug) \
		$(use_enable libnotify inotify) \
		$(use_with magic libmagic) \
		$(use_enable xft)
}

src_install() {
	default
	if use examples; then
		docinto examples
		dodoc examples/config-*
	fi
}
