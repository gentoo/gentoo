# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils

DESCRIPTION="LINGOT Is Not a Guitar-Only Tuner"
HOMEPAGE="http://www.nongnu.org/lingot"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack"

RDEPEND="x11-libs/gtk+:2
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	dev-libs/glib:2
	gnome-base/libglade:2.0
	alsa? ( media-libs/alsa-lib )
	jack? ( >=media-sound/jack-audio-connection-kit-0.102 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.7.6-clean-install.patch \
		"${FILESDIR}"/${P}-jack.patch

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable alsa) \
		$(use_enable jack)
}

src_install() {
	emake DESTDIR="${D}" lingotdocdir="/usr/share/doc/${PF}" install
}
