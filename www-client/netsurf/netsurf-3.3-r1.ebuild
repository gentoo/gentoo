# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/netsurf/netsurf-3.3-r1.ebuild,v 1.2 2015/08/04 13:00:08 xmw Exp $

EAPI=5

NETSURF_COMPONENT_TYPE=binary
NETSURF_BUILDSYSTEM=buildsystem-1.3
inherit netsurf

DESCRIPTION="a free, open source web browser"
HOMEPAGE="http://www.netsurf-browser.org/"
SRC_URI="http://download.netsurf-browser.org/netsurf/releases/source/${P}-src.tar.gz
	http://xmw.de/mirror/netsurf-fb.modes-example.gz
	${NETSURF_BUILDSYSTEM_SRC_URI}"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="+bmp fbcon truetype +gif gstreamer gtk javascript +jpeg +mng pdf-writer
	+png +rosprite +svg +svgtiny +webp fbcon_frontend_able fbcon_frontend_linux
	fbcon_frontend_sdl fbcon_frontend_vnc fbcon_frontend_x"

REQUIRED_USE="|| ( fbcon gtk )
	amd64? ( abi_x86_32? ( !javascript ) )
	fbcon? ( ^^ ( fbcon_frontend_able fbcon_frontend_linux fbcon_frontend_sdl
		fbcon_frontend_vnc fbcon_frontend_x ) )"

RDEPEND="=dev-libs/libnsutils-0.0.1-r1[${MULTILIB_USEDEP}]
	=dev-libs/libutf8proc-1.1.6-r1[${MULTILIB_USEDEP}]
	dev-libs/libxml2:2[${MULTILIB_USEDEP}]
	net-misc/curl[${MULTILIB_USEDEP}]
	>=dev-libs/libcss-0.5.0-r1[${MULTILIB_USEDEP}]
	>=net-libs/libhubbub-0.3.1-r1[${MULTILIB_USEDEP}]
	net-libs/libdom[${MULTILIB_USEDEP}]
	bmp? ( >=media-libs/libnsbmp-0.1.2-r1[${MULTILIB_USEDEP}] )
	fbcon? ( >=dev-libs/libnsfb-0.1.3-r1[${MULTILIB_USEDEP}]
		truetype? ( media-fonts/dejavu
			>=media-libs/freetype-2.5.0.1[${MULTILIB_USEDEP}] )
	)
	gif? ( >=media-libs/libnsgif-0.1.2-r1[${MULTILIB_USEDEP}] )
	gtk? ( >=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
		gnome-base/libglade:2.0[${MULTILIB_USEDEP}]
		>=x11-libs/gtk+-2.24.23:2[${MULTILIB_USEDEP}] )
	gstreamer? ( media-libs/gstreamer:0.10[${MULTILIB_USEDEP}] )
	javascript? ( >=dev-libs/nsgenbind-0.1.2-r1[${MULTILIB_USEDEP}]
		dev-lang/spidermonkey:0= )
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	mng? ( >=media-libs/libmng-1.0.10-r2[${MULTILIB_USEDEP}] )
	pdf-writer? ( media-libs/libharu[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.2.51:0[${MULTILIB_USEDEP}] )
	svg? ( svgtiny? ( >=media-libs/libsvgtiny-0.1.3-r1[${MULTILIB_USEDEP}] )
		!svgtiny? ( gnome-base/librsvg:2[${MULTILIB_USEDEP}] ) )
	webp? ( >=media-libs/libwebp-0.3.0[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	rosprite? ( >=media-libs/librosprite-0.1.2-r1[${MULTILIB_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${P}-CFLAGS.patch
	"${FILESDIR}"/${PN}-3.0-framebuffer-pkgconfig.patch
	"${FILESDIR}"/${PN}-3.2-conditionally-include-image-headers.patch )
DOCS=( fb.modes README Docs/USING-Framebuffer
	Docs/ideas/{cache,css-engine,render-library}.txt )

src_prepare() {
	rm -rf amiga atari beos cocoa monkey riscos windows  || die

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
		NETSURF_USE_PNG=$(usex png YES NO)
		NETSURF_USE_MNG=$(usex mng YES NO)
		NETSURF_USE_WEBP=$(usex webp YES NO)
		NETSURF_USE_VIDEO=$(usex gstreamer YES NO)
		NETSURF_USE_MOZJS=$(usex javascript YES NO)
		NETSURF_USE_JS=NO
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
	)
}

src_compile() {
	if use fbcon ; then
		netsurf_makeconf=( "${netsurf_makeconf[@]/TARGET=*/TARGET=framebuffer}" )
		netsurf_src_compile
	fi
	if use gtk ; then
		netsurf_makeconf=( "${netsurf_makeconf[@]/TARGET=*/TARGET=gtk}" )
		netsurf_src_compile
	fi
}

src_install() {
	sed -e '1iexit;' \
		-i "${WORKDIR}"/*/utils/git-testament.pl || die

	if use fbcon ; then
		netsurf_makeconf=( "${netsurf_makeconf[@]/TARGET=*/TARGET=framebuffer}" )
		netsurf_src_install
		elog "framebuffer binary has been installed as netsurf-fb"
		pushd "${ED}"usr/bin >/dev/null || die
		for f in netsurf{,.*} ; do
			mv -v $f ${f/netsurf/netsurf-fb} || die
			make_desktop_entry "${EROOT}"usr/bin/${f/netsurf/netsurf-fb} NetSurf-framebuffer${f/netsurf} netsurf "Network;WebBrowser"
		done
		popd >/dev/null || die
		elog "In order to setup the framebuffer console, netsurf needs an /etc/fb.modes"
		elog "You can use an example from /usr/share/doc/${PF}/fb.modes.* (bug 427092)."
		elog "Please make /etc/input/mice readable to the account using netsurf-fb."
		elog "Either use chmod a+r /etc/input/mice (security!!!) or use an group."
	fi
	if use gtk ; then
		netsurf_makeconf=( "${netsurf_makeconf[@]/TARGET=*/TARGET=gtk}" )
		netsurf_src_install
		elog "netsurf gtk version has been installed as netsurf-gtk"
		pushd "${ED}"usr/bin >/dev/null || die
		for f in netsurf{,.*} ; do
			mv -v $f ${f/netsurf/netsurf-gtk} || die
			make_desktop_entry "${EROOT}"usr/bin/${f/netsurf/netsurf-gtk} NetSurf-gtk${f/netsurf} netsurf "Network;WebBrowser"
		done
		popd >/dev/null || die
	fi

	insinto /usr/share/pixmaps
	doins gtk/res/netsurf.xpm
}
