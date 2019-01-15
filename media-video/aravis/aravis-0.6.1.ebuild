# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://github.com/AravisProject/aravis.git"
	inherit git-r3 autotools
else
	SRC_URI="mirror://gnome/sources/${PN}/$(ver_cut 1-2)/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Library for video acquisition using Genicam cameras"
HOMEPAGE="https://wiki.gnome.org/Projects/Aravis"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="X gstreamer caps"

GST_DEPEND="media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0"

RDEPEND=">=dev-libs/glib-2.32
	dev-libs/libxml2
	X? (
		>=x11-libs/gtk+-3.12:3
		${GST_DEPEND}
		media-libs/gst-plugins-base:1.0
		x11-libs/libnotify
	)
	caps? (
		sys-libs/libcap-ng
		sys-process/audit
	)
	gstreamer? ( ${GST_DEPEND} )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-libs/gobject-introspection"

if [[ ${PV} != *9999 ]]; then
	DEPEND+=" dev-util/gtk-doc dev-util/intltool"
fi

src_prepare() {
	default
	if [[ ${PV} = *9999 ]]; then
		intltoolize || die
		gtkdocize || die
		eautoreconf
	fi
}

src_configure() {
	econf \
		--disable-silent-rules \
		--disable-static \
		$(use_enable X viewer) \
		$(use_enable gstreamer gst-plugin) \
		$(use_enable caps packet-socket) \
		--enable-introspection
}

src_install() {
	emake install DESTDIR="${D}" aravisdocdir="/usr/share/doc/${PF}"
	find "${D}" -name '*.la' -delete
}
