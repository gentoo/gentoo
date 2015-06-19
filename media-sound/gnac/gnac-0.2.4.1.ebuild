# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gnac/gnac-0.2.4.1.ebuild,v 1.1 2012/08/28 00:51:56 radhermit Exp $

EAPI=4

inherit eutils autotools gnome2

DESCRIPTION="Audio converter for GNOME"
HOMEPAGE="http://gnac.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnac/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LANGS=" cs da de en_GB es gl fr he hu it lt nb pt_BR pl ro ru sl sv te tr zh_CN"
IUSE="aac flac libnotify mp3 nls wavpack ${LANGS// / linguas_}"

RDEPEND="x11-libs/gtk+:3
	dev-libs/libunique:3
	dev-libs/libxml2:2
	libnotify? ( x11-libs/libnotify )
	>=media-libs/gstreamer-0.10.31:0.10
	>=media-libs/gst-plugins-base-0.10.31:0.10
	media-plugins/gst-plugins-gio:0.10
	media-plugins/gst-plugins-meta:0.10[flac?,mp3?,wavpack?]
	aac? ( media-plugins/gst-plugins-faac:0.10 )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.17.2
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cflags.patch
	epatch "${FILESDIR}"/${P}-nls.patch

	gnome2_src_prepare
	eautoreconf
}

src_configure() {
	G2CONF="${G2CONF} $(use_enable nls)"
	gnome2_src_configure
}
