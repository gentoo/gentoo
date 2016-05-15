# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="Mixer library for MATE Desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+alsa oss pulseaudio"

RDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	>=dev-libs/glib-2.36:2
	sys-devel/gettext:*
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.23:0[alsa?,glib] )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0:*
	virtual/pkgconfig:*"

src_configure() {
	gnome2_src_configure \
		--disable-null \
		$(use_enable alsa) \
		$(use_enable oss) \
		$(use_enable pulseaudio)
}

DOCS="AUTHORS ChangeLog NEWS README"
