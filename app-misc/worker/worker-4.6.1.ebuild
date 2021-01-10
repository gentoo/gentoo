# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Worker Filemanager: Amiga Directory Opus 4 clone"
HOMEPAGE="http://www.boomerangsworld.de/cms/worker/"
SRC_URI="http://www.boomerangsworld.de/cms/worker/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="avfs debug dbus examples libnotify lua +magic xinerama xft"

RDEPEND="x11-libs/libX11
	avfs? ( >=sys-fs/avfs-0.9.5 )
	dbus? (	sys-apps/dbus )
	lua? ( dev-lang/lua:0 )
	magic? ( sys-apps/file )
	xft? ( x11-libs/libXft )
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog INSTALL NEWS README README_LARGEFILES THANKS )

src_prepare() {
	default

	# Don't use /usr/share/appdata
	sed -i -e "s:/appdata:/metainfo:" contrib/Makefile.am || die
	eautoreconf
}

src_configure() {
	# there is no ./configure flag to disable libXinerama support
	export ac_cv_lib_Xinerama_XineramaQueryScreens=$(usex xinerama)
	econf \
		--without-hal \
		--enable-utf8 \
		$(use_with avfs) \
		$(use_with dbus) \
		$(use_enable debug) \
		$(use_enable libnotify inotify) \
		$(use_enable lua) \
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
