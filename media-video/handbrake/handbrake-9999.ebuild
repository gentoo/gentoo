# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit autotools python-any-r1 toolchain-funcs xdg

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/HandBrake/HandBrake.git"
	inherit git-r3
else
	MY_P="HandBrake-${PV}"
	SRC_URI="https://github.com/HandBrake/HandBrake/releases/download/${PV}/${MY_P}-source.tar.bz2 -> ${P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Open-source, GPL-licensed, multiplatform, multithreaded video transcoder"
HOMEPAGE="https://handbrake.fr/ https://github.com/HandBrake/HandBrake"

LICENSE="GPL-2"
SLOT="0"
IUSE="+fdk gstreamer gtk libav-aac numa nvenc x265"

REQUIRED_USE="^^ ( fdk libav-aac )"

RDEPEND="
	app-arch/xz-utils
	dev-libs/jansson:=
	dev-libs/libxml2
	media-libs/a52dec
	>=media-libs/dav1d-0.5.1:=
	media-libs/libjpeg-turbo:=
	media-libs/libass:=
	>=media-libs/libbluray-1.0:=
	media-libs/libdvdnav
	media-libs/libdvdread:=
	media-libs/libsamplerate
	media-libs/libtheora
	media-libs/libvorbis
	>=media-libs/libvpx-1.8:=
	media-libs/opus
	media-libs/speex
	media-libs/x264:=
	media-libs/zimg
	media-sound/lame
	>=media-video/ffmpeg-4.2.1:0=[postproc,fdk?]
	sys-libs/zlib
	fdk? ( media-libs/fdk-aac:= )
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
	nvenc? ( media-libs/nv-codec-headers )
	x265? ( >=media-libs/x265-3.2:0=[10bit,12bit,numa?] )
"
DEPEND="${RDEPEND}"
# cmake needed for custom script: bug #852701
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/nasm
	dev-util/cmake
	dev-util/intltool
"

PATCHES=(
	# Remove libdvdnav duplication and call it on the original instead.
	# It may work this way; if not, we should try to mimic the duplication.
	"${FILESDIR}/${PN}-9999-remove-dvdnav-dup.patch"

	# Remove faac dependency; TODO: figure out if we need to do this at all.
	"${FILESDIR}/${PN}-9999-remove-faac-dependency.patch"

	# Detect system tools - bug 738110
	"${FILESDIR}/${PN}-9999-system-tools.patch"

	# Use whichever python is set by portage
	"${FILESDIR}/${PN}-1.3.0-dont-search-for-python.patch"

	# Fix x265 linkage... again again #730034
	"${FILESDIR}/${PN}-1.3.3-x265-link.patch"
)

src_prepare() {
	# Get rid of leftover bundled library build definitions,
	sed -i 's:.*\(/contrib\|contrib/\).*::g' \
		"${S}"/make/include/main.defs \
		|| die "Contrib removal failed."

	default

	cd "${S}/gtk" || die
	eautoreconf
}

src_configure() {
	tc-export AR RANLIB STRIP

	# Libav was replaced in 1.2 with ffmpeg by default
	# but I've elected to not make people change their use flags for AAC
	# as its the same code anyway
	local myconfargs=(
		--force
		--verbose
		--prefix="${EPREFIX}/usr"
		--disable-gtk-update-checks
		--disable-flatpak
		--disable-gtk4
		$(use_enable libav-aac ffmpeg-aac)
		$(use_enable fdk fdk-aac)
		$(usex !gtk --disable-gtk)
		$(usex !gstreamer --disable-gst)
		$(use_enable numa)
		$(use_enable nvenc)
		$(use_enable x265)
	)

	./configure "${myconfargs[@]}" || die "Configure failed."
}

src_compile() {
	emake -C build
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

	xdg_pkg_postinst
}
