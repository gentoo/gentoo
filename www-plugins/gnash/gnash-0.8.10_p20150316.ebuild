# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CMAKE_REQUIRED="never"
KDE_REQUIRED="optional"
AT_M4DIR="cygnal"
# won't build with python-3, bug #392969
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils kde4-base multilib nsplugins python-any-r1 flag-o-matic

DESCRIPTION="GNU Flash movie player that supports many SWF v7,8,9 features"
HOMEPAGE="https://www.gnu.org/software/gnash/"

if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
	EGIT_REPO_URI="git://git.savannah.gnu.org/gnash.git"
	inherit git-2
else
# Release tarball is b0rked, upstream #35612
#	SRC_URI="mirror://gnu/${PN}/${PV}/${P}.tar.bz2"
	SRC_URI="mirror://gentoo/${P}.tar.xz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="X +agg cairo cygnal dbus directfb doc dump egl fbcon +ffmpeg gconf gnome gstreamer gtk harden jemalloc kde lirc mysql +nls nsplugin opengl openvg python sdl +sdl-sound ssh ssl test vaapi"
REQUIRED_USE="dump? ( agg ffmpeg )
	fbcon? ( agg )
	nsplugin? ( gtk )
	openvg? ( egl )
	python? ( gtk )
	vaapi? ( agg ffmpeg )
	|| ( agg cairo opengl openvg )
	|| ( dump fbcon gtk kde sdl )
	"

RDEPEND=">=dev-libs/boost-1.41.0:0=
	dev-libs/expat
	dev-libs/libxml2
	virtual/jpeg
	media-libs/libpng
	net-misc/curl
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXt
	media-libs/giflib
	x11-proto/xproto
	agg? ( x11-libs/agg )
	cairo? ( x11-libs/cairo )
	directfb? (
		dev-libs/DirectFB
	)
	doc? (
		>=app-text/docbook2X-0.8.8
		app-text/docbook-sgml-utils
	)
	egl? (
		media-libs/mesa[egl]
	)
	fbcon? (
		x11-libs/tslib
	)
	ffmpeg? (
		virtual/ffmpeg[vaapi?]
	)
	gconf? (
		gnome-base/gconf
	)
	gstreamer? (
		media-plugins/gst-plugins-ffmpeg
		media-plugins/gst-plugins-mad
		media-plugins/gst-plugins-meta
	)
	gtk? (
		x11-libs/gtk+:2
		python? ( dev-python/pygtk:2 )
	)
	jemalloc? ( dev-libs/jemalloc )
	kde? ( $(add_kdebase_dep kdebase-startkde) )
	opengl? (
		virtual/glu
		virtual/opengl
		gtk? ( x11-libs/gtkglext )
	)
	openvg? (
		media-libs/mesa[openvg]
	)
	sdl? ( media-libs/libsdl[X] )
	sdl-sound? ( media-libs/libsdl )
	media-libs/speex[ogg]
	sys-libs/zlib
	>=sys-devel/libtool-2.2
	mysql? ( virtual/mysql )
	lirc? ( app-misc/lirc )
	dbus? ( sys-apps/dbus )
	ssh?  ( >=net-libs/libssh-0.4[server] )
	ssl? ( dev-libs/openssl )
	vaapi? ( x11-libs/libva[opengl?] )
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	gnome? ( app-text/rarian )
	nsplugin? ( net-misc/npapi-sdk )
	test? ( dev-util/dejagnu )"
# Tests hang with sandbox, bug #321017
RESTRICT="test"

pkg_setup() {
	kde4-base_pkg_setup
	python-any-r1_pkg_setup

	if use !ffmpeg && use !gstreamer; then
		ewarn "You are trying to build Gnash without choosing a media handler."
		ewarn "Sound and video playback will not work."
	fi
}

src_unpack() {
	default
	# rename git snapshot directory to what portage expects
	mv ${PN}-*/ ${P} || die
}

src_prepare() {
	# Fix paths for klash, bug #339610
	epatch "${FILESDIR}"/${PN}-0.8.9-klash.patch

	# Use external dejagnu for tests, bug #321017
	epatch "${FILESDIR}"/${PN}-0.8.9-external-dejagnu.patch

	# Fix building on ppc64, bug #342535
	use ppc64 && append-flags -mminimal-toc

	# Fix kde multilib library path, bug #391283
	epatch "${FILESDIR}"/${PN}-0.8.9-kde4-libdir.patch

	# Fix libamf includes
	epatch "${FILESDIR}"/${PN}-0.8.10-amf-include.patch

	eautoreconf
}
src_configure() {
	local device gui input media myconf myext renderers

	# Set nsplugin install directory.
	use nsplugin && myconf="${myconf} --with-npapi-plugindir=/usr/$(get_libdir)/gnash/npapi/"

	# Set hardware acceleration.
	use X && device+=",x11"
	use directfb && device+=",directfb"
	use egl && device+=",egl"
	use fbcon && device+=",rawfb"
	use vaapi && device+=",vaapi"
	[[ "${device}x" == "x" ]] && device+=",none"

	# Set rendering engine.
	use agg && renderers+=",agg"
	use cairo && renderers+=",cairo"
	use opengl && renderers+=",opengl"
	use openvg && renderers+=",openvg"

	# Set kde and konqueror plugin directories.
	if use kde; then
		myconf="${myconf}
			--with-plugins-install=system
			--with-kde4-incl=${KDEDIR}/include
			--with-kde4-configdir=${KDEDIR}/share/config
			--with-kde4-prefix=${KDEDIR}
			--with-kde4-lib=${KDEDIR}/$(get_libdir)
			--with-kde-appsdatadir=${KDEDIR}/share/apps/klash
			--with-kde4-servicesdir=${KDEDIR}/share/kde4/services
			--with-kde4-plugindir=${KDEDIR}/$(get_libdir)/kde4"
	fi

	# Set media handler.
	use ffmpeg || use gstreamer || media+=",none"
	use ffmpeg && media+=",ffmpeg"
	use gstreamer && media+=",gst"

	# Set gui.
	use dump && gui="${gui},dump"
	use fbcon && gui="${gui},fb"
	use gtk && gui=",gtk"
	use kde && gui="${gui},kde4"
	use sdl && gui="${gui},sdl"

	if use sdl-sound; then
		myconf="${myconf} --enable-sound=sdl"
	else
		myconf="${myconf} --enable-sound=none"
	fi

	# Set extensions
	use mysql && myext=",mysql"
	use gtk && myext="${myext},gtk"
	use lirc && myext="${myext},lirc"
	use dbus && myext="${myext},dbus"

	# Strip extra comma from gui, myext, hwaccel and renderers.
	device=$( echo $device | sed -e 's/,//' )
	gui=$( echo $gui | sed -e 's/,//' )
	myext=$( echo $myext | sed -e 's/,//' )
	renderers=$( echo $renderers | sed -e 's/,//' )
	media=$( echo $media | sed -e 's/,//' )

	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-dependency-tracking \
		--disable-kparts3 \
		$(use_enable cygnal) \
		$(use_enable cygnal cgibins) \
		$(use_enable doc docbook) \
		$(use_enable gnome ghelp) \
		$(use_enable harden) \
		$(use_enable jemalloc) \
		$(use_enable kde kparts4) \
		$(use_enable nls) \
		$(use_enable nsplugin npapi) \
		$(use_enable python) \
		$(use_enable ssh) \
		$(use_enable ssl) \
		$(use_enable test testsuite) \
		$(use_with gconf) \
		--enable-gui=${gui} \
		--enable-device=${device} \
		--enable-extensions=${myext} \
		--enable-renderer=${renderers} \
		--enable-media=${media} \
		${myconf}
}
src_test() {
	local log=testsuite-results.txt
	cd testsuite
	emake check || die "make check failed"
	./anaylse-results.sh > $log || die "results analyze failed"
	cat $log
}
src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# Install nsplugin in directory set by --with-npapi-plugindir.
	if use nsplugin; then
		emake DESTDIR="${D}" install-plugin || die "install plugins failed"
	fi

	# Install kde konqueror plugin.
	if use kde; then
		pushd "${S}/plugin/klash4" >& /dev/null || die
		emake DESTDIR="${D}" install-plugin || die "install kde plugins failed"
		popd >& /dev/null
	fi
	# Create a symlink in /usr/$(get_libdir)/nsbrowser/plugins to the nsplugin install directory.
	use nsplugin && inst_plugin /usr/$(get_libdir)/gnash/npapi/libgnashplugin.so

	# Remove eglinfo, bug #463654
	if use egl; then
		rm -f "${D}"/usr/bin/eglinfo || die
	fi

	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
pkg_postinst() {
	if use !gnome || use !gstreamer && use !ffmpeg ; then
		ewarn ""
		ewarn "Gnash was built without a media handler and or http handler !"
		ewarn ""
		ewarn "If you want Gnash to support video then you will need to"
		ewarn "rebuild Gnash with either the ffmpeg or gstreamer and gnome use flags set."
		ewarn ""
	fi
	ewarn "${PN} is still in heavy development"
	ewarn "Please first report bugs on upstream gnashdevs and deal with them"
	ewarn "And then report a Gentoo bug to the maintainer"
	use kde && kde4-base_pkg_postinst
}
