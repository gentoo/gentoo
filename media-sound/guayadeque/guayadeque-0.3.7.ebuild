# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="2.8"

inherit cmake-utils eutils wxwidgets

DESCRIPTION="Music management program designed for all music enthusiasts"
HOMEPAGE="http://guayadeque.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ayatana ipod +minimal"

# No test available, Making src_test fail
RESTRICT="test"

# Missing
# gstreamer0.10-fluendo-mp3 #120237
# gstreamer0.10-plugins-bad-multiverse ??
# gstreamer0.10-plugins-base-apps ??

GST_VERSION=0.10
GST_DEPS="
	dev-perl/GStreamer
	media-libs/gnonlin:${GST_VERSION}
	media-plugins/gst-plugins-alsa:${GST_VERSION}
	media-plugins/gst-plugins-ffmpeg:${GST_VERSION}
	media-plugins/gst-plugins-gio:${GST_VERSION}
	media-plugins/gst-plugins-gnomevfs:${GST_VERSION}
	media-plugins/gst-plugins-libnice:${GST_VERSION}
	media-plugins/gst-plugins-pulse:${GST_VERSION}
	media-plugins/gst-plugins-soup:${GST_VERSION}
	media-plugins/gst-plugins-x:${GST_VERSION}
	media-libs/gst-plugins-bad:${GST_VERSION}
	media-libs/gst-plugins-base:${GST_VERSION}
	media-libs/gst-plugins-good:${GST_VERSION}
	media-libs/gst-plugins-ugly:${GST_VERSION}
"

RDEPEND="
	dev-db/sqlite:3
	dev-db/wxsqlite3
	dev-libs/glib:2
	media-libs/flac
	media-libs/gstreamer:${GST_VERSION}[introspection]
	>=media-libs/taglib-1.6.4
	net-misc/curl
	sys-apps/dbus
	x11-libs/wxGTK:2.8[X]
	ayatana? ( >=dev-libs/libindicate-0.7 )
	ipod? ( media-libs/libgpod )
	!minimal? ( ${GST_DEPS} )"
DEPEND="${RDEPEND}
	app-arch/unzip
	sys-devel/gettext
	virtual/pkgconfig"

# echo $(cat po/CMakeLists.txt | grep ADD_SUBDIRECTORY | sed 's#ADD_SUBDIRECTORY( \(\w\+\) )#\1#')
LANGS="es uk it de fr is nb th cs ru hu sv nl pt_BR pt el sk pl tr ja sr bg ca_ES hr"
for l in ${LANGS}; do
	IUSE="$IUSE linguas_${l}"
done

PATCHES=( "${FILESDIR}"/${PN}-0.3.6*-underlinking.patch )

src_prepare() {
	for l in ${LANGS} ; do
		if ! use linguas_${l} ; then
			sed \
				-e "/${l}/d" \
				-i po/CMakeLists.txt || die
		fi
	done

	if ! use ipod; then
		sed \
			-e '/PKG_CHECK_MODULES( LIBGPOD/,/^ENDIF/d' \
			-i CMakeLists.txt || die
	fi

	if ! use ayatana; then
		sed \
			-e '/PKG_CHECK_MODULES( LIBINDICATE/,/^ENDIF/d' \
			-i CMakeLists.txt || die
	fi

	rm -rf src/wx/wxsql* src/wxsqlite3 || die

	cmake-utils_src_prepare

	# otherwise cmake checks for svn
	esvn_clean

	sed 's:-O2::g' -i CMakeLists.txt || die

	sed \
		-e '/Encoding/d' \
		-i guayadeque.desktop || die
}

pkg_postinst() {
	local pkg
	if use minimal; then
		elog "If you are missing functionalities consider setting USE=-minimal"
		elog "or install any of the following packages:"
		for pkg in ${GST_DEPS}; do
			elog "\t ${pkg}"
		done
	fi
}
