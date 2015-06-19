# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/miro/miro-4.0.6.ebuild,v 1.1 2012/02/16 19:43:33 jdhore Exp $

EAPI=3

PYTHON_DEPEND="2:2.7"
PYTHON_USE_WITH="sqlite"
inherit eutils fdo-mime gnome2-utils distutils

DESCRIPTION="Open source video player and podcast client"
HOMEPAGE="http://www.getmiro.com/"
SRC_URI="http://ftp.osuosl.org/pub/pculture.org/${PN}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="libnotify aac musepack xvid"

CDEPEND="
	dev-libs/glib:2
	>=dev-python/pyrex-0.9.6.4
	dev-python/pygtk:2
	dev-python/pygobject:2
	>=virtual/ffmpeg-0.6.90"

RDEPEND="${CDEPEND}
	dev-python/dbus-python
	dev-python/pycairo
	dev-python/gconf-python
	dev-python/gst-python:0.10
	dev-python/pyrex
	>=dev-python/pywebkitgtk-1.1.5
	dev-python/pycurl
	>=net-libs/rb_libtorrent-0.14.1[python]
	media-libs/mutagen
	media-plugins/gst-plugins-meta:0.10
	media-plugins/gst-plugins-pango:0.10
	aac? ( media-plugins/gst-plugins-faad:0.10 )
	libnotify? ( dev-python/notify-python )
	musepack? ( media-plugins/gst-plugins-musepack:0.10 )
	xvid? ( media-plugins/gst-plugins-xvid:0.10 )"

DEPEND="${CDEPEND}"

S="${WORKDIR}/${P}/linux"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	distutils_src_prepare
}

src_install() {
	# doing the mv now otherwise, distutils_src_install will install it
	mv README README.gtk || die "mv failed"

	distutils_src_install

	# installing docs
	dodoc README.gtk ../{CREDITS,README} || die "dodoc failed"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update

	ewarn
	ewarn "If miro doesn't play some video or audio format, please"
	ewarn "check your USE flags on media-plugins/gst-plugins-meta"
	ewarn
	elog "Miro for Linux doesn't support Adobe Flash, therefore you"
	elog "you will not see any embedded video player on MiroGuide."
	elog
}

pkg_postrm() {
	distutils_pkg_postrm
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
