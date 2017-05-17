# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils toolchain-funcs

DESCRIPTION="Most feature-rich GUI for net-libs/tox using Qt5"
HOMEPAGE="https://github.com/qTox/qTox"
SRC_URI="https://github.com/qTox/qTox/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk X"

# needed, since tarball provided by github extracts to `qTox`
S="${WORKDIR}/qTox-${PV}"

RDEPEND="
	dev-db/sqlcipher
	dev-libs/libsodium
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5=
	dev-qt/qtgui:5[gif,jpeg,png,xcb]
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-gfx/qrencode
	media-libs/openal
	>=media-video/ffmpeg-2.6.3[webp,v4l]
	gtk? (	dev-libs/atk
			dev-libs/glib:2
			x11-libs/gdk-pixbuf[X]
			x11-libs/gtk+:2
			x11-libs/cairo[X]
			x11-libs/pango[X] )
	net-libs/tox:0/0.1[av]
	X? ( x11-libs/libX11
		x11-libs/libXScrnSaver )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if tc-is-gcc ; then
			if [[ $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 8 || $(gcc-major-version) -lt 4 ]] ; then
				eerror "You need at least sys-devel/gcc-4.8.3"
				die "You need at least sys-devel/gcc-4.8.3"
			fi
		fi
	fi
}

src_configure() {
	use gtk || local NO_GTK_SUPPORT="ENABLE_SYSTRAY_STATUSNOTIFIER_BACKEND=NO ENABLE_SYSTRAY_GTK_BACKEND=NO"
	use X || local NO_X_SUPPORT="DISABLE_PLATFORM_EXT=YES"
	eqmake5 \
			PREFIX="${D}/usr" \
			GIT_DESCRIBE="${PV}" \
			${NO_GTK_SUPPORT} \
			${NO_X_SUPPORT}
}
