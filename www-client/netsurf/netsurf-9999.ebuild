# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop git-r3 netsurf toolchain-funcs

DESCRIPTION="A free, open source web browser"
HOMEPAGE="https://www.netsurf-browser.org/"

EGIT_REPO_URI="https://git.netsurf-browser.org/${PN}.git"
LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS=""
IUSE="bmp fbcon truetype +gif +gtk +javascript +jpeg
	+png +psl rosprite +svg +svgtiny +webp"

REQUIRED_USE="|| ( fbcon gtk )"

RDEPEND="
	>=dev-libs/libcss-9999
	>=dev-libs/libnsutils-9999
	dev-libs/openssl:=
	dev-libs/libutf8proc
	dev-libs/libxml2:2
	net-misc/curl
	>=net-libs/libdom-9999
	net-libs/libhubbub
	bmp? ( media-libs/libnsbmp )
	fbcon? (
		dev-libs/libnsfb
		truetype? (
			media-fonts/dejavu
			media-libs/freetype
		)
	)
	gif? ( >=media-libs/libnsgif-9999 )
	gtk? (
		dev-libs/glib:2
		x11-libs/gtk+:3
	)
	javascript? (
		dev-libs/nsgenbind
		dev-lang/duktape:=
	)
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng:0= )
	psl? ( media-libs/libnspsl )
	rosprite? ( media-libs/librosprite )
	svg? (
		svgtiny? ( media-libs/libsvgtiny )
		!svgtiny? ( gnome-base/librsvg:2 )
	)
	webp? ( media-libs/libwebp )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/check
	dev-perl/HTML-Parser
	dev-util/netsurf-buildsystem
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-3.9-conditionally-include-image-headers.patch"
	"${FILESDIR}/${PN}-3.10-julia-libutf8proc-header-location.patch"
	"${FILESDIR}/${PN}-3.10-disable-failing-tests.patch"
)

DOCS=(
	README
	docs/using-framebuffer.md
	docs/ideas/{cache,css-engine,render-library}.txt
)

src_prepare() {
	default
	rm -r frontends/{amiga,atari,beos,monkey,riscos,windows} || die
}

_emake() {
	netsurf_define_makeconf
	local netsurf_makeconf=(
		"${NETSURF_MAKECONF[@]}"
		COMPONENT_TYPE=binary
		NETSURF_FB_FONTLIB=$(usex truetype freetype internal)
		NETSURF_FB_FONTPATH="${EPREFIX}/usr/share/fonts/dejavu"
		NETSURF_USE_BMP=$(usex bmp YES NO)
		NETSURF_USE_DUKTAPE=$(usex javascript YES NO)
		NETSURF_USE_GIF=$(usex gif YES NO)
		NETSURF_USE_JPEG=$(usex jpeg YES NO)
		NETSURF_USE_PNG=$(usex png YES NO)
		NETSURF_USE_NSPSL=$(usex psl YES NO)
		NETSURF_USE_NSSVG=$(usex svg $(usex svgtiny YES NO) NO)
		NETSURF_USE_OPENSSL=YES
		NETSURF_USE_ROSPRITE=$(usex rosprite YES NO)
		NETSURF_USE_RSVG=$(usex svg $(usex svgtiny NO YES) NO)
		NETSURF_USE_WEBP=$(usex webp YES NO)
		NETSURF_USE_VIDEO=NO
		PKG_CONFIG=$(tc-getPKG_CONFIG)
	)

	emake "${netsurf_makeconf[@]}" $@
}

src_compile() {
	# The build system only runs pkg-config to find librsvg's include
	# dir for the gtk targets. So if you try to build the framebuffer
	# target with NETSURF_USE_RSVG=YES, the build crashes on failing to
	# find rsvg.h. To work around that, we set NETSURF_USE_RSVG=NO. It
	# might be possible to fall back to svgtiny with USE="svg -svgtiny"
	# if svgtiny works in a framebuffer, but then our (R)DEPEND would
	# need some mangling to ensure that svgtiny is installed.
	use fbcon && _emake NETSURF_USE_RSVG=NO TARGET=framebuffer

	use gtk && _emake TARGET=gtk3
}

src_test() {
	_emake test
}

src_install() {
	if use fbcon ; then
		# See earlier comments about rsvg.h.
		_emake NETSURF_USE_RSVG=NO TARGET=framebuffer DESTDIR="${D}" install
		elog "framebuffer binary has been installed as netsurf-fb"
		make_desktop_entry "${EPREFIX}/usr/bin/netsurf-fb %u" \
						   NetSurf-framebuffer \
						   netsurf \
						   "Network;WebBrowser"
	fi
	if use gtk ; then
		_emake TARGET=gtk3 DESTDIR="${D}" install
		elog "netsurf gtk3 version has been installed as netsurf-gtk3"
		make_desktop_entry "${EPREFIX}/usr/bin/netsurf-gtk3 %u" \
						   NetSurf-gtk3 \
						   netsurf \
						   "Network;WebBrowser"
	fi

	insinto /usr/share/pixmaps
	doins frontends/gtk/res/netsurf.xpm
	doman docs/netsurf-fb.1
	doman docs/netsurf-gtk.1
}
