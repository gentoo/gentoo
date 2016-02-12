# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils flag-o-matic gnome2

DESCRIPTION="Audio converter for GNOME"
HOMEPAGE="http://gnac.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnac/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LANGS=" cs da de en_GB es gl fr he hu it lt nb pt_BR pl ro ru sl sv te tr zh_CN"
IUSE="aac flac libnotify mp3 nls wavpack ${LANGS// / linguas_}"

RDEPEND="
	x11-libs/gtk+:3
	dev-libs/libunique:3
	dev-libs/libxml2:2
	libnotify? ( x11-libs/libnotify )
	>=media-libs/gstreamer-0.10.31:0.10
	>=media-libs/gst-plugins-base-0.10.31:0.10
	media-plugins/gst-plugins-gio:0.10
	media-plugins/gst-plugins-meta:0.10[flac?,mp3?,wavpack?]
	aac? ( media-plugins/gst-plugins-faac:0.10 )
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.17.2
	gnome-base/gnome-common
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
PATCHES=(
	"${FILESDIR}/${P}-cflags.patch"
	"${FILESDIR}/${P}-nls.patch"
)

src_prepare() {
	default
	epatch -p1 "${PATCHES[@]}"

	# fix bug 574568 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure $(use_enable nls)
}
