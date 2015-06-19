# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/handbrake/handbrake-0.10.1.ebuild,v 1.1 2015/05/15 16:58:16 thev00d00 Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2-utils python-any-r1

if [[ ${PV} = *9999* ]]; then
	ESVN_REPO_URI="svn://svn.handbrake.fr/HandBrake/trunk"
	inherit subversion
	KEYWORDS=""
else
	SRC_URI="http://handbrake.fr/rotation.php?file=HandBrake-${PV}.tar.bz2 -> ${P}.tar.bz2"
	S="${WORKDIR}/HandBrake-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Open-source, GPL-licensed, multiplatform, multithreaded video transcoder"
HOMEPAGE="http://handbrake.fr/"
LICENSE="GPL-2"

SLOT="0"
IUSE="+fdk gstreamer gtk libav libav-aac"

REQUIRED_USE="^^ ( fdk libav-aac )"

RDEPEND="
	dev-libs/jansson
	media-libs/a52dec
	media-libs/libass
	media-libs/libbluray
	media-libs/libdvdnav
	media-libs/libdvdread
	media-libs/libsamplerate
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/libvpx
	media-libs/x264:=
	media-sound/lame
	sys-libs/zlib
	libav? ( >=media-video/libav-10.1:0= )
	!libav? ( >=media-video/ffmpeg-2.3:0= )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-ugly:1.0
		media-plugins/gst-plugins-a52dec:1.0
		media-plugins/gst-plugins-libav:1.0
		media-plugins/gst-plugins-x264:1.0
	)
	gtk? (
		>=x11-libs/gtk+-3.10
		dev-libs/dbus-glib
		dev-libs/glib:2
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/libnotify
		x11-libs/pango
		virtual/libgudev:=
	)
	fdk? ( media-libs/fdk-aac )
	"
	#x265? ( =media-libs/x265-1.4 )

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/yasm
	dev-util/intltool
	sys-devel/automake"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	# Get rid of leftover bundled library build definitions,
	sed -i 's:.*\(/contrib\|contrib/\).*::g' \
		"${S}"/make/include/main.defs \
		|| die "Contrib removal failed."

	# Remove libdvdnav duplication and call it on the original instead.
	# It may work this way; if not, we should try to mimic the duplication.
	epatch "${FILESDIR}"/${PN}-9999-remove-dvdnav-dup.patch

	# Remove faac dependency; TODO: figure out if we need to do this at all.
	epatch "${FILESDIR}"/${PN}-9999-remove-faac-dependency.patch

	cd "${S}/gtk"
	# Don't run autogen.sh.
	sed -i '/autogen.sh/d' module.rules || die "Removing autogen.sh call failed"
	eautoreconf
}

src_configure() {
	./configure \
		--force \
		--verbose \
		--prefix="${EPREFIX}/usr" \
		--disable-gtk-update-checks \
		$(use_enable libav-aac) \
		$(use_enable fdk fdk-aac) \
		$(use_enable gtk) \
		$(usex !gstreamer --disable-gst) \
		--disable-x265 || die "Configure failed."
	#	$(use_enable x265) \
}

src_compile() {
	emake -C build

	# TODO: Documentation building is currently broken, try to fix it.
	#
	# if use doc ; then
	# 	emake -C build doc
	# fi
}

src_install() {
	emake -C build DESTDIR="${D}" install

	dodoc AUTHORS CREDITS NEWS THANKS TRANSLATIONS
}

pkg_postinst() {
	einfo "For the CLI version of HandBrake, you can use \`HandBrakeCLI\`."

	if use gtk ; then
		einfo ""
		einfo "For the GTK+ version of HandBrake, you can run \`ghb\`."
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
