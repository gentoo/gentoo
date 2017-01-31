# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

NETSURF_COMPONENT_TYPE=binary
NETSURF_BUILDSYSTEM=buildsystem-1.5
inherit netsurf

DESCRIPTION="a free, open source web browser"
HOMEPAGE="http://www.netsurf-browser.org/"
SRC_URI="http://download.netsurf-browser.org/netsurf/releases/source/${P}-src.tar.gz
	http://xmw.de/mirror/netsurf-fb.modes-example.gz
	${NETSURF_BUILDSYSTEM_SRC_URI}"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc"
IUSE="+bmp +duktape fbcon truetype +gif gstreamer gtk gtk2 gtk3 +javascript +jpeg +mng
	pdf-writer +png +psl +rosprite +svg +svgtiny +webp fbcon_frontend_able
	fbcon_frontend_linux fbcon_frontend_sdl fbcon_frontend_vnc fbcon_frontend_x"

REQUIRED_USE="|| ( fbcon gtk gtk2 gtk3 )
	amd64? ( abi_x86_32? ( javascript? ( duktape ) ) )
	fbcon? ( ^^ ( fbcon_frontend_able fbcon_frontend_linux fbcon_frontend_sdl
		fbcon_frontend_vnc fbcon_frontend_x ) )
	duktape? ( javascript )"

RDEPEND=">=dev-libs/libnsutils-0.0.2[${MULTILIB_USEDEP}]
	>=dev-libs/libutf8proc-1.1.6-r1[${MULTILIB_USEDEP}]
	dev-libs/libxml2:2[${MULTILIB_USEDEP}]
	net-misc/curl[${MULTILIB_USEDEP}]
	>=dev-libs/libcss-0.6.0[${MULTILIB_USEDEP}]
	>=net-libs/libhubbub-0.3.1-r1[${MULTILIB_USEDEP}]
	>=net-libs/libdom-0.3.0[${MULTILIB_USEDEP}]
	bmp? ( >=media-libs/libnsbmp-0.1.2-r1[${MULTILIB_USEDEP}] )
	fbcon? ( >=dev-libs/libnsfb-0.1.3-r1[${MULTILIB_USEDEP}]
		truetype? ( media-fonts/dejavu
			>=media-libs/freetype-2.5.0.1[${MULTILIB_USEDEP}] )
	)
	gif? ( >=media-libs/libnsgif-0.1.2-r1[${MULTILIB_USEDEP}] )
	gtk2? ( dev-libs/glib:2[${MULTILIB_USEDEP}]
		x11-libs/gtk+:2[${MULTILIB_USEDEP}] )
	gtk3? ( dev-libs/glib:2[${MULTILIB_USEDEP}]
		x11-libs/gtk+:3[${MULTILIB_USEDEP}] )
	gtk? ( dev-libs/glib:2[${MULTILIB_USEDEP}]
		x11-libs/gtk+:3[${MULTILIB_USEDEP}] )
	gstreamer? ( media-libs/gstreamer:0.10[${MULTILIB_USEDEP}] )
	javascript? ( >=dev-libs/nsgenbind-0.3[${MULTILIB_USEDEP}]
		!duktape? ( dev-lang/spidermonkey:0= ) )
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	mng? ( >=media-libs/libmng-1.0.10-r2[${MULTILIB_USEDEP}] )
	pdf-writer? ( media-libs/libharu[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.2.51:0[${MULTILIB_USEDEP}] )
	psl? ( media-libs/libnspsl[${MULTILIB_USEDEP}] )
	rosprite? ( >=media-libs/librosprite-0.1.2-r1[${MULTILIB_USEDEP}] )
	svg? ( svgtiny? ( >=media-libs/libsvgtiny-0.1.3-r1[${MULTILIB_USEDEP}] )
		!svgtiny? ( gnome-base/librsvg:2[${MULTILIB_USEDEP}] ) )
	webp? ( >=media-libs/libwebp-0.3.0[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-libs/check[${MULTILIB_USEDEP}]
	dev-perl/HTML-Parser"

PATCHES=( "${FILESDIR}"/${PN}-3.6-CFLAGS.patch
	"${FILESDIR}"/${PN}-3.6-conditionally-include-image-headers.patch
	"${FILESDIR}"/${PN}-3.6-pdf-writer.patch
	"${FILESDIR}"/${PN}-3.6-gstreamer.patch )
DOCS=( fb.modes README Docs/USING-Framebuffer
	Docs/ideas/{cache,css-engine,render-library}.txt )

src_prepare() {
	rm -r frontends/{amiga,atari,beos,cocoa,monkey,riscos,windows} || die

	mv "${WORKDIR}"/netsurf-fb.modes-example fb.modes

	netsurf_src_prepare
}

src_configure() {
	netsurf_src_configure

	netsurf_makeconf+=(
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
		NETSURF_USE_HARU_PDF=$(usex pdf-writer YES NO)
		NETSURF_USE_NSSVG=$(usex svg $(usex svgtiny YES NO) NO)
		NETSURF_USE_RSVG=$(usex svg $(usex svgtiny NO YES) NO)
		NETSURF_USE_ROSPRITE=$(usex rosprite YES NO)
		PKG_CONFIG=$(tc-getPKG_CONFIG)
		$(usex fbcon_frontend_able  NETSURF_FB_FRONTEND=able  "")
		$(usex fbcon_frontend_linux NETSURF_FB_FRONTEND=linux "")
		$(usex fbcon_frontend_sdl   NETSURF_FB_FRONTEND=sdl   "")
		$(usex fbcon_frontend_vnc   NETSURF_FB_FRONTEND=vnc   "")
		$(usex fbcon_frontend_x     NETSURF_FB_FRONTEND=x     "")
		NETSURF_FB_FONTLIB=$(usex truetype freetype internal)
		NETSURF_FB_FONTPATH=${EROOT}usr/share/fonts/dejavu
		TARGET=dummy
		NETSURF_USE_VIDEO=dummy
	)
}

src_compile() {
	if use fbcon ; then
		netsurf_makeconf=( "${netsurf_makeconf[@]/TARGET=*/TARGET=framebuffer}" )
		netsurf_makeconf=( "${netsurf_makeconf[@]/NETSURF_USE_VIDEO=*/NETSURF_USE_VIDEO=NO}" )
		netsurf_src_compile
	fi
	if use gtk2 ; then
		netsurf_makeconf=( "${netsurf_makeconf[@]/TARGET=*/TARGET=gtk}" )
		netsurf_makeconf=( "${netsurf_makeconf[@]/NETSURF_USE_VIDEO=*/NETSURF_USE_VIDEO=$(usex gstreamer YES NO)}" )
		netsurf_src_compile
	fi
	if use gtk3 || use gtk ; then
		netsurf_makeconf=( "${netsurf_makeconf[@]/TARGET=*/TARGET=gtk3}" )
		netsurf_makeconf=( "${netsurf_makeconf[@]/NETSURF_USE_VIDEO=*/NETSURF_USE_VIDEO=$(usex gstreamer YES NO)}" )
		netsurf_src_compile
	fi
}

src_install() {
	sed -e '1iexit;' \
		-i "${WORKDIR}"/*/utils/git-testament.pl || die

	if use fbcon ; then
		netsurf_makeconf=( "${netsurf_makeconf[@]/TARGET=*/TARGET=framebuffer}" )
		netsurf_makeconf=( "${netsurf_makeconf[@]/NETSURF_USE_VIDEO=*/NETSURF_USE_VIDEO=NO}" )
		netsurf_src_install
		elog "framebuffer binary has been installed as netsurf-fb"
		make_desktop_entry "${EROOT}"usr/bin/netsurf-fb NetSurf-framebuffer netsurf "Network;WebBrowser"
		elog "In order to setup the framebuffer console, netsurf needs an /etc/fb.modes"
		elog "You can use an example from /usr/share/doc/${PF}/fb.modes.* (bug 427092)."
		elog "Please make /dev/input/mice readable to the account using netsurf-fb."
		elog "Either use chmod a+r /dev/input/mice (security!!!) or use an group."
	fi
	if use gtk2 ; then
		netsurf_makeconf=( "${netsurf_makeconf[@]/TARGET=*/TARGET=gtk}" )
		netsurf_makeconf=( "${netsurf_makeconf[@]/NETSURF_USE_VIDEO=*/NETSURF_USE_VIDEO=$(usex gstreamer YES NO)}" )
		netsurf_src_install
		elog "netsurf gtk2 version has been installed as netsurf-gtk"
		make_desktop_entry "${EROOT}"usr/bin/netsurf-gtk NetSurf-gtk netsurf "Network;WebBrowser"
	fi
	if use gtk3 || use gtk ; then
		netsurf_makeconf=( "${netsurf_makeconf[@]/TARGET=*/TARGET=gtk3}" )
		netsurf_makeconf=( "${netsurf_makeconf[@]/NETSURF_USE_VIDEO=*/NETSURF_USE_VIDEO=$(usex gstreamer YES NO)}" )
		netsurf_src_install
		elog "netsurf gtk3 version has been installed as netsurf-gtk3"
		make_desktop_entry "${EROOT}"usr/bin/netsurf-gtk3 NetSurf-gtk3 netsurf "Network;WebBrowser"
	fi

	insinto /usr/share/pixmaps
	doins frontends/gtk/res/netsurf.xpm
}
