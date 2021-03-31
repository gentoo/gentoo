# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit netsurf desktop

DESCRIPTION="a free, open source web browser"
HOMEPAGE="https://www.netsurf-browser.org/"
SRC_URI="http://download.netsurf-browser.org/netsurf/releases/source/${P}-src.tar.gz"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"
IUSE="bmp +duktape fbcon truetype +gif +gtk gtk2 +javascript +jpeg mng
	+png +psl rosprite +svg +svgtiny +webp"

REQUIRED_USE="|| ( fbcon gtk gtk2 )
	duktape? ( javascript )"

RDEPEND="
	>=dev-libs/libcss-0.9
	>=net-libs/libdom-0.3
	>=net-libs/libhubbub-0.3
	>=dev-libs/libnsutils-0.1.0
	>=dev-libs/libutf8proc-2.4
	dev-libs/libxml2:2
	net-misc/curl
	bmp? ( >=media-libs/libnsbmp-0.1 )
	fbcon? ( >=dev-libs/libnsfb-0.2.2
		truetype? ( media-fonts/dejavu
			>=media-libs/freetype-2.5.0.1 )
	)
	gif? ( >=media-libs/libnsgif-0.1 )
	gtk? ( dev-libs/glib:2
		x11-libs/gtk+:3 )
	gtk2? ( dev-libs/glib:2
		x11-libs/gtk+:2 )
	javascript? (
		>=dev-libs/nsgenbind-0.7
		duktape? ( dev-lang/duktape:= )
		!duktape? ( dev-lang/spidermonkey:0= )
	)
	jpeg? ( >=virtual/jpeg-0-r2:0 )
	mng? ( >=media-libs/libmng-1.0.10-r2 )
	png? ( >=media-libs/libpng-1.2.51:0 )
	psl? ( media-libs/libnspsl )
	rosprite? ( >=media-libs/librosprite-0.1.2-r1 )
	svg? ( svgtiny? ( >=media-libs/libsvgtiny-0.1.3-r1 )
		!svgtiny? ( gnome-base/librsvg:2 ) )
	webp? ( >=media-libs/libwebp-0.3.0 )"
BDEPEND="
	duktape? ( app-editors/vim-core )
	dev-libs/check
	dev-perl/HTML-Parser
	>=dev-util/netsurf-buildsystem-1.7-r1"

PATCHES=(
	"${FILESDIR}/${PN}-3.9-conditionally-include-image-headers.patch"
	"${FILESDIR}/${PN}-3.10-julia-libutf8proc-header-location.patch"
	"${FILESDIR}/${PN}-3.10-disable-failing-tests.patch"
)

DOCS=( README docs/using-framebuffer.md
	docs/ideas/{cache,css-engine,render-library}.txt )

src_prepare() {
	default
	rm -r frontends/{amiga,atari,beos,monkey,riscos,windows} || die
}

_emake() {
	netsurf_define_makeconf
	local netsurf_makeconf=(
		"${NETSURF_MAKECONF[@]}"
		COMPONENT_TYPE=binary
		NETSURF_USE_BMP=$(usex bmp YES NO)
		NETSURF_USE_GIF=$(usex gif YES NO)
		NETSURF_USE_JPEG=$(usex jpeg YES NO)
		NETSURF_USE_PNG=$(usex png YES NO)
		NETSURF_USE_NSPSL=$(usex psl YES NO)
		NETSURF_USE_MNG=$(usex mng YES NO)
		NETSURF_USE_WEBP=$(usex webp YES NO)
		NETSURF_USE_MOZJS=$(usex javascript $(usex duktape NO YES) NO)
		NETSURF_USE_JS=NO
		NETSURF_USE_DUKTAPE=$(usex javascript $(usex duktape YES NO) NO)
		NETSURF_USE_NSSVG=$(usex svg $(usex svgtiny YES NO) NO)
		NETSURF_USE_RSVG=$(usex svg $(usex svgtiny NO YES) NO)
		NETSURF_USE_ROSPRITE=$(usex rosprite YES NO)
		PKG_CONFIG=$(tc-getPKG_CONFIG)
		NETSURF_FB_FONTLIB=$(usex truetype freetype internal)
		NETSURF_FB_FONTPATH="${EPREFIX}/usr/share/fonts/dejavu"
		NETSURF_USE_VIDEO=NO
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

	use gtk2 && _emake TARGET=gtk2
	use gtk && _emake TARGET=gtk3
}

src_test() {
	_emake test
}

src_install() {
	sed -e '1iexit;' \
		-i "${WORKDIR}"/*/utils/git-testament.pl || die

	if use fbcon ; then
		# See earlier comments about rsvg.h.
		_emake NETSURF_USE_RSVG=NO TARGET=framebuffer DESTDIR="${D}" install
		elog "framebuffer binary has been installed as netsurf-fb"
		make_desktop_entry "${EPREFIX}"/usr/bin/netsurf-fb \
						   NetSurf-framebuffer \
						   netsurf \
						   "Network;WebBrowser"
	fi
	if use gtk2 ; then
		_emake TARGET=gtk2 DESTDIR="${D}" install
		elog "netsurf gtk2 version has been installed as netsurf-gtk2"
		make_desktop_entry "${EPREFIX}"/usr/bin/netsurf-gtk2 \
						   NetSurf-gtk2 \
						   netsurf \
						   "Network;WebBrowser"
	fi
	if use gtk ; then
		_emake TARGET=gtk3 DESTDIR="${D}" install
		elog "netsurf gtk3 version has been installed as netsurf-gtk3"
		make_desktop_entry "${EPREFIX}"/usr/bin/netsurf-gtk3 \
						   NetSurf-gtk3 \
						   netsurf \
						   "Network;WebBrowser"
	fi

	insinto /usr/share/pixmaps
	doins frontends/gtk/res/netsurf.xpm
	doman docs/netsurf-fb.1
	doman docs/netsurf-gtk.1
}
