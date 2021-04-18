# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO: USE xine could be restored if support for xine-lib-1.2.x
# is patched in wrt #397639

EAPI=6

inherit epatch libtool ltprune

DESCRIPTION="Powerful GTK+ based image & movie viewer"
HOMEPAGE="http://gtkmmviewer.sourceforge.net/"
SRC_URI="mirror://sourceforge/gtkmmviewer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 x86"
IUSE="mng nls mplayer svg wmf" #xine

RDEPEND="app-arch/bzip2
	x11-libs/gtk+:2
	>=media-libs/libpng-1.2:0=
	x11-libs/libXinerama
	wmf? ( >=media-libs/libwmf-0.2.8 )
	mng? ( media-libs/libmng:= )
	svg? ( gnome-base/librsvg )
	mplayer? ( media-video/mplayer )"
#xine? ( media-libs/xine-lib )
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

src_prepare() {
	# link gimv executable against -lm for floor() and pow()
	sed -i -e 's/$(gimv_LDADD)/& -lm/' src/Makefile.in || die #417995

	epatch \
		"${FILESDIR}"/${P}-sort_fix.diff \
		"${FILESDIR}"/${P}-gtk12_fix.diff \
		"${FILESDIR}"/${P}-gtk2.patch \
		"${FILESDIR}"/${P}-libpng15.patch

	# desktop-file-validate
	sed -i \
		-e '/^Term/s:0:false:' \
		-e '/^Icon/s:.png::' \
		etc/${PN}.desktop.in || die

	eapply_user
	elibtoolize
}

src_configure() {
	econf \
		--disable-imlib \
		$(use_enable nls) \
		--enable-splash \
		$(use_enable mplayer) \
		--with-gtk2 \
		$(use_with mng libmng) \
		$(use_with svg librsvg) \
		$(use_with wmf libwmf) \
		--without-xine
}

src_install() {
	emake \
		bindir="${ED}usr/bin" \
		datadir="${ED}usr/share" \
		desktopdir="${ED}usr/share/applications" \
		gimv_docdir="${ED}usr/share/doc/${PF}" \
		libdir="${ED}usr/$(get_libdir)" \
		install

	prune_libtool_files --all
}
