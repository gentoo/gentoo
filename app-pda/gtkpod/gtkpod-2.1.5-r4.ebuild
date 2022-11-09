# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Not all modules needed by py script are packaged in Gentoo
#PYTHON_COMPAT=( python3_{6..9} )

inherit autotools flag-o-matic gnome2-utils xdg #python-single-r1

DESCRIPTION="A graphical user interface to the Apple productline"
HOMEPAGE="http://www.gtkpod.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 FDL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="aac clutter curl cdr flac gstreamer mp3 vorbis"
REQUIRED_USE="cdr? ( gstreamer )"

# ${PYTHON_DEPS}
COMMON_DEPEND="
	>=dev-libs/gdl-3.6:3
	>=dev-libs/glib-2.31:2
	>=dev-libs/libxml2-2.7.7:2
	>=dev-util/anjuta-3.6
	>=media-libs/libgpod-0.8.2
	>=media-libs/libid3tag-0.15:=
	>=x11-libs/gtk+-3.0.8:3
	aac? ( media-libs/faad2 )
	clutter? ( >=media-libs/clutter-gtk-1.2:1.0 )
	curl? ( >=net-misc/curl-7.10 )
	flac? ( media-libs/flac:= )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		cdr? (
			>=app-cdr/brasero-3
			>=media-libs/libdiscid-0.2.2
			media-libs/musicbrainz:5
		)
	)
	mp3? ( media-sound/lame )
	vorbis? (
		media-libs/libvorbis
		media-sound/vorbis-tools
	)
"

# to pull in at least -flac and -vorbis plugins , but others at the same time
RDEPEND="${COMMON_DEPEND}
	gstreamer? ( media-plugins/gst-plugins-meta:1.0 )
"
# media-libs/gstreamer:1.0 needed at build time as we need m4 file for
# eautoreconf, bug #659748
DEPEND="${COMMON_DEPEND}
	media-libs/gstreamer:1.0
	dev-util/intltool
	sys-devel/flex
	sys-devel/gettext
	virtual/os-headers
	virtual/pkgconfig
"

src_prepare() {
	xdg_src_prepare

	eapply "${FILESDIR}"/${PN}-2.1.3-gold.patch
	eapply "${FILESDIR}"/${PN}-2.1.5-m4a.patch

#	python_fix_shebang scripts/
#	2to3 --no-diffs -w scripts/sync-palm-jppy.py || die

	gnome2_disable_deprecation_warning

	eautoreconf
}

src_configure() {
	# Prevent sandbox violations, bug #420279
	addpredict /dev

	append-flags -fcommon #722504

	econf \
		--enable-deprecations \
		--disable-static \
		--disable-plugin-coverweb \
		$(use_enable clutter plugin-clarity) \
		$(use_enable gstreamer plugin-media-player) \
		$(use_enable cdr plugin-sjcd) \
		$(use_with curl) \
		$(use_with vorbis ogg) \
		$(use_with flac) \
		$(use_with aac mp4)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF}/html \
		figuresdir=/usr/share/doc/${PF}/html/figures \
		install

	dodoc AUTHORS ChangeLog NEWS README TODO TROUBLESHOOTING
	rm -f "${ED}"/usr/share/gtkpod/data/{AUTHORS,COPYING} || die

	# Needs unpackaged python modules
	rm -f "${ED}"/usr/share/gtkpod/scripts/sync-palm-jppy.py || die

	find "${D}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}
