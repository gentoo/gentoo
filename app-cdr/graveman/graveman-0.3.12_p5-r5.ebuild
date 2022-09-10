# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools gnome2

DESCRIPTION="Graphical frontend for cdrecord, mkisofs, readcd and sox using GTK+2"
HOMEPAGE="http://graveman.tuxfamily.org/"
SRC_URI="http://graveman.tuxfamily.org/sources/${PN}-${PV/_p/-}.tar.gz"
S="${WORKDIR}/${P/_p/-}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="debug dvdr flac mp3 nls vorbis"

RDEPEND="
	app-cdr/cdrdao
	app-cdr/cdrtools
	>=dev-libs/glib-2.4:2
	>=gnome-base/libglade-2.4:2.0
	media-libs/libmng:=
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.4:2
	dvdr? ( app-cdr/dvd+rw-tools )
	flac? ( media-libs/flac:= )
	mp3? (
		media-libs/libid3tag:=
		media-libs/libmad
		media-sound/sox
	)
	nls? ( virtual/libintl )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
		media-sound/sox
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	eapply \
		"${FILESDIR}"/joliet-long.patch \
		"${FILESDIR}"/rename.patch \
		"${FILESDIR}"/desktop-entry.patch \
		"${FILESDIR}"/cflags.patch

	if use mp3 || use vorbis; then
		eapply "${FILESDIR}"/sox.patch
	fi

	# Fix tests
	cat <<- EOF >> po/POTFILES.in || die
		glade/dialog_media.glade
		glade/window_welcome.glade
		src/flac.c
	EOF

	# Prevent m4_copy error when running aclocal
	# m4_copy: won't overwrite defined macro: glib_DEFUN, bug #579918
	rm m4/glib-gettext.m4 || die

	eautoreconf # Needed for build only the needed translations
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable debug) \
		$(use_enable flac) \
		$(use_enable mp3) \
		$(use_enable vorbis ogg)
}
