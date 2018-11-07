# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs desktop

NETSURF_BUILDSYSTEM=buildsystem-1.7

# The netsurf project enthusiastically fragments its code in many little
# libraries. It's all fine and dandy, until comes the time to package it. Very
# few of those libraries are used anywhere else have their development process
# very tightly coupled to netsurf's. Moreover, they all use netsurf's weird
# build system. Packaging those libraries individually creates a lot of
# overhead. We try to minimize that overhead by grouping the worst offenders
# (in terms of "single-purposeness") in this ebuild. This is generally not the
# Gentoo way, but doing otherwise makes netsurf's footprint in the Gentoo tree
# disproportionally high in relation to the program's importance.
NETSURF_LIBS_URL="http://download.netsurf-browser.org/libs/releases"
NETSURF_LIBS=(
	"libnsutils-0.0.5"
	"libcss-0.8.0"
	"libnsbmp-0.1.5 bmp"
	"libnsfb-0.2.0 fbcon"
	"libnsgif-0.2.1 gif"
	"libnspsl-0.1.3 psl"
	"librosprite-0.1.3 rosprite"
	"libsvgtiny-0.1.7 svgtiny"
	"nsgenbind-0.6 javascript"
)
NETSURF_STATIC_LIBS_TARGET="${WORKDIR}/inst"

DESCRIPTION="a free, open source web browser"
HOMEPAGE="http://www.netsurf-browser.org/"
SRC_URI="http://download.netsurf-browser.org/netsurf/releases/source/${P}-src.tar.gz
	${NETSURF_LIBS_URL}/${NETSURF_BUILDSYSTEM}.tar.gz -> netsurf-${NETSURF_BUILDSYSTEM}.tar.gz"

for netsurf_lib in "${NETSURF_LIBS[@]}"; do
	netsurf_lib=( $netsurf_lib )
	netsurf_lib_uri="${NETSURF_LIBS_URL}/${netsurf_lib[0]}-src.tar.gz"
	if [[ -z "${netsurf_lib[1]}" ]]; then
		SRC_URI+=" ${netsurf_lib_uri}"
	else
		SRC_URI+=" ${netsurf_lib[1]}? ( ${netsurf_lib_uri} )"
	fi
done

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc"
IUSE="+bmp +duktape fbcon truetype +gif gtk gtk2 +javascript +jpeg +mng
	pdf-writer +png +psl +rosprite +svg +svgtiny +webp
	fbcon_frontend_sdl fbcon_frontend_vnc fbcon_frontend_x"

REQUIRED_USE="|| ( fbcon gtk gtk2 )
	fbcon? ( || ( fbcon_frontend_sdl fbcon_frontend_vnc fbcon_frontend_x ) )
	duktape? ( javascript )"

RDEPEND="
	>=net-libs/libdom-0.3[xml]
	>=dev-libs/libutf8proc-2.2
	net-misc/curl
	fbcon? (
		truetype? ( media-fonts/dejavu >=media-libs/freetype-2.5.0.1 )
	)
	fbcon_frontend_sdl? ( >=media-libs/libsdl-1.2.15-r4 )
	fbcon_frontend_vnc? ( >=net-libs/libvncserver-0.9.9-r2 )
	fbcon_frontend_x? (
		>=x11-libs/libxcb-1.9.1
		>=x11-libs/xcb-util-0.3.9-r1
		>=x11-libs/xcb-util-image-0.3.9-r1
		>=x11-libs/xcb-util-keysyms-0.3.9-r1 )
	gtk? ( dev-libs/glib:2 x11-libs/gtk+:3 )
	gtk2? ( dev-libs/glib:2 x11-libs/gtk+:2 )
	javascript? (
		virtual/yacc
		!duktape? ( dev-lang/spidermonkey:0= ) )
	jpeg? ( >=virtual/jpeg-0-r2:0 )
	mng? ( >=media-libs/libmng-1.0.10-r2 )
	pdf-writer? ( media-libs/libharu )
	png? ( >=media-libs/libpng-1.2.51:0 )
	svg? ( !svgtiny? ( gnome-base/librsvg:2 ) )
	webp? ( >=media-libs/libwebp-0.3.0 )"
DEPEND="${RDEPEND}
	dev-libs/check
	dev-perl/HTML-Parser"

PATCHES=(
	"${FILESDIR}"/${PN}-3.8-CFLAGS.patch
	"${FILESDIR}"/${PN}-3.6-conditionally-include-image-headers.patch
	"${FILESDIR}"/${PN}-3.8-pdf-writer.patch
)

DOCS=( README docs/using-framebuffer.md
	docs/ideas/{cache,css-engine,render-library}.txt )

src_prepare() {
	default
	rm -r frontends/{amiga,atari,beos,monkey,riscos,windows} || die
}

netsurf_patch_build() {
	sed -e "/^INSTALL_ITEMS/s: /lib: /$(get_libdir):g" \
		-i Makefile || die
	if [ -f ${PN}.pc.in ] ; then
		sed -e "/^libdir/s:/lib:/$(get_libdir):g" \
			-i ${PN}.pc.in || die
	fi
}

src_configure() {
	netsurf_base_makeconf=(
		NSSHARED=${WORKDIR}/${NETSURF_BUILDSYSTEM}
		Q=
		CC="$(tc-getCC)"
		LD="$(tc-getLD)"
		HOST_CC="\$(CC)"
		CCOPT=
		CCNOOPT=
		CCDBG=
		LDDBG=
		AR="$(tc-getAR)"
	)

	sed -e 's:/bin/which:which:' \
		-i "${WORKDIR}/${NETSURF_BUILDSYSTEM}/makefiles/Makefile.tools" || die

	local netsurf_lib
	for netsurf_lib in "${NETSURF_LIBS[@]}"; do
		netsurf_lib=( $netsurf_lib )
		# if it's not there, its because its USE flag is not selected
		if cd "${WORKDIR}/${netsurf_lib[0]}"; then
			netsurf_patch_build
		fi
	done

	cd "${S}" || die
	netsurf_patch_build

	PKG_CONFIG_PATH="${NETSURF_STATIC_LIBS_TARGET}/lib/pkgconfig"
	PATH="${PATH}:${NETSURF_STATIC_LIBS_TARGET}/bin"
	netsurf_libs_makeconf=(
		"${netsurf_base_makeconf[@]}"
		PREFIX="${NETSURF_STATIC_LIBS_TARGET}"
	)
	netsurf_makeconf=(
		"${netsurf_base_makeconf[@]}"
		PREFIX="${EROOT}"usr
		LIBDIR="$(get_libdir)"
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
		NETSURF_FB_FONTLIB=$(usex truetype freetype internal)
		NETSURF_FB_FONTPATH=${EROOT}usr/share/fonts/dejavu
		NETSURF_USE_VIDEO=NO
	)
}

src_compile() {
	local netsurf_lib
	for netsurf_lib in "${NETSURF_LIBS[@]}"; do
		netsurf_lib=( $netsurf_lib )
		# if it's not there, its because its USE flag is not selected
		if cd "${WORKDIR}/${netsurf_lib[0]}"; then
			emake "${netsurf_libs_makeconf[@]}" install
		fi
	done

	cd "${S}" || die
	use fbcon && emake "${netsurf_makeconf[@]}" TARGET=framebuffer
	use gtk2 && emake "${netsurf_makeconf[@]}" TARGET=gtk
	use gtk && emake "${netsurf_makeconf[@]}" TARGET=gtk3
}

src_test() {
	emake "${netsurf_makeconf[@]}" test
}

src_install() {
	sed -e '1iexit;' \
		-i "${WORKDIR}"/*/utils/git-testament.pl || die

	if use fbcon ; then
		emake "${netsurf_makeconf[@]}" DESTDIR="${D}" TARGET=framebuffer install
		elog "framebuffer binary has been installed as netsurf-fb"
		make_desktop_entry "${EROOT}"/usr/bin/netsurf-fb NetSurf-framebuffer netsurf "Network;WebBrowser"
	fi
	if use fbcon_frontend_sdl; then
		elog "To be able to use netsurf without X, don't forget to enable the "
		elog "proper USE flags in libsdl (fbcon). Also, make /dev/input/mice "
		elog "readable to the account using netsurf-fb. Either use chmod a+r "
		elog "/dev/input/mice (security!!!) or use a group."
	fi
	if use gtk2 ; then
		emake "${netsurf_makeconf[@]}" DESTDIR="${D}" TARGET=gtk install
		elog "netsurf gtk2 version has been installed as netsurf-gtk"
		make_desktop_entry "${EROOT}"/usr/bin/netsurf-gtk NetSurf-gtk netsurf "Network;WebBrowser"
	fi
	if use gtk ; then
		emake "${netsurf_makeconf[@]}" DESTDIR="${D}" TARGET=gtk3 install
		elog "netsurf gtk3 version has been installed as netsurf-gtk3"
		make_desktop_entry "${EROOT}"/usr/bin/netsurf-gtk3 NetSurf-gtk3 netsurf "Network;WebBrowser"
	fi

	insinto /usr/share/pixmaps
	doins frontends/gtk/res/netsurf.xpm
}
