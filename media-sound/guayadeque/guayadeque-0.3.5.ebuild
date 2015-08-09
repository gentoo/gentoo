# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

WX_GTK_VER="2.8"

inherit cmake-utils eutils wxwidgets

DESCRIPTION="Music management program designed for all music enthusiasts"
HOMEPAGE="http://guayadeque.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ayatana ipod"

# No test available, Making src_test fail
RESTRICT="test"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
	media-libs/flac
	media-libs/gstreamer:0.10
	media-libs/taglib
	media-plugins/gst-plugins-soup:0.10
	net-misc/curl
	sys-apps/dbus
	x11-libs/wxGTK:2.8[X]
	ayatana? ( dev-libs/libindicate )
	ipod? ( media-libs/libgpod )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	dev-util/cmake"

# echo $(cat po/CMakeLists.txt | grep ADD_SUBDIRECTORY | sed 's#ADD_SUBDIRECTORY( \(\w\+\) )#\1#')
LANGS="es uk it de fr is nb th cs ru hu sv nl"
for l in ${LANGS}; do
	IUSE="$IUSE linguas_${l}"
done

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

	cmake-utils_src_prepare

	# otherwise cmake checks for svn
	esvn_clean

	sed 's:-O2::g' -i CMakeLists.txt || die

	sed \
		-e '/Encoding/d' \
		-i guayadeque.desktop || die
}

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
