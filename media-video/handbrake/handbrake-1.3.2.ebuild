# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit autotools eutils gnome2-utils python-any-r1 xdg-utils

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/HandBrake/HandBrake.git"
	inherit git-r3
	KEYWORDS=""
else
	MY_P="HandBrake-${PV}"
	SRC_URI="https://github.com/HandBrake/HandBrake/releases/download/${PV}/${MY_P}-source.tar.bz2 -> ${P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Open-source, GPL-licensed, multiplatform, multithreaded video transcoder"
HOMEPAGE="http://handbrake.fr/"
LICENSE="GPL-2"

SLOT="0"
IUSE="+fdk gstreamer gtk libav-aac numa nvenc x265"

REQUIRED_USE="^^ ( fdk libav-aac )"

RDEPEND="
	app-arch/xz-utils
	media-libs/speex
	dev-libs/jansson
	dev-libs/libxml2
	media-libs/a52dec
	media-libs/libass:=
	>=media-libs/libbluray-1.0
	>=media-libs/dav1d-0.5.1
	media-libs/libdvdnav
	media-libs/libdvdread:=
	media-libs/libsamplerate
	media-libs/libtheora
	media-libs/libvorbis
	>=media-libs/libvpx-1.8
	nvenc? ( media-libs/nv-codec-headers )
	media-libs/opus
	media-libs/x264:=
	media-sound/lame
	sys-libs/zlib
	>=media-video/ffmpeg-4.2.1:0=[fdk?]
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-ugly:1.0
		media-plugins/gst-plugins-a52dec:1.0
		media-plugins/gst-plugins-libav:1.0
		media-plugins/gst-plugins-x264:1.0
		media-plugins/gst-plugins-gdkpixbuf:1.0
	)
	gtk? (
		>=x11-libs/gtk+-3.10
		dev-libs/dbus-glib
		dev-libs/glib:2
		dev-libs/libgudev:=
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/libnotify
		x11-libs/pango
	)
	fdk? ( media-libs/fdk-aac )
	x265? ( >=media-libs/x265-3.2:0=[10bit,12bit,numa?] )
	"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/yasm
	dev-util/intltool
	sys-devel/automake"

PATCHES=(
	# Remove libdvdnav duplication and call it on the original instead.
	# It may work this way; if not, we should try to mimic the duplication.
	"${FILESDIR}/${PN}-9999-remove-dvdnav-dup.patch"

	# Remove faac dependency; TODO: figure out if we need to do this at all.
	"${FILESDIR}/${PN}-9999-remove-faac-dependency.patch"

	# Use whichever python is set by portage
	"${FILESDIR}/${PN}-1.3.0-dont-search-for-python.patch"
)

src_prepare() {
	# Get rid of leftover bundled library build definitions,
	sed -i 's:.*\(/contrib\|contrib/\).*::g' \
		"${S}"/make/include/main.defs \
		|| die "Contrib removal failed."

	default

	cd "${S}/gtk"
	# Don't run autogen.sh.
	sed -i '/autogen.sh/d' module.rules || die "Removing autogen.sh call failed"
	eautoreconf
}

src_configure() {
	# Libav was replaced in 1.2 with ffmpeg by default
	# but I've elected to not make people change their use flags for AAC
	# as its the same code anyway
	./configure \
		--force \
		--verbose \
		--prefix="${EPREFIX}/usr" \
		--disable-gtk-update-checks \
		--disable-flatpak \
		--disable-gtk4 \
		$(use_enable libav-aac ffmpeg-aac) \
		$(use_enable fdk fdk-aac) \
		$(usex !gtk --disable-gtk) \
		$(usex !gstreamer --disable-gst) \
		$(use_enable numa) \
		$(use_enable nvenc) \
		$(use_enable x265) || die "Configure failed."
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

	dodoc README.markdown AUTHORS.markdown NEWS.markdown THANKS.markdown
}

pkg_postinst() {
	einfo "Gentoo builds of HandBrake are NOT SUPPORTED by upstream as they"
	einfo "do not use the bundled (and often patched) upstream libraries."
	einfo ""
	einfo "Please do not raise bugs with upstream because of these ebuilds,"
	einfo "report bugs to Gentoo's bugzilla or Multimedia forum instead."

	einfo "For the CLI version of HandBrake, you can use \`HandBrakeCLI\`."
	if use gtk ; then
		einfo "For the GTK+ version of HandBrake, you can run \`ghb\`."
	fi

	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
