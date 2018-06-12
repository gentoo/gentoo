# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

KEYWORDS="~amd64"

if [[ ${PV} == "9999" ]]; then
	KEYWORDS=""
	EGIT_REPO_URI="git://git.gnome.org/aravis"
	EGIT_COMMIT="${aravis_LIVE_COMMIT:-master}"
	inherit git-2 autotools
fi

DESCRIPTION="Library for video acquisition using Genicam cameras"
HOMEPAGE="https://live.gnome.org/Aravis"

LICENSE="LGPL-2.1"
SLOT="0"

IUSE="X gstreamer caps"

GST_DEPEND="media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0"

RDEPEND=">=dev-libs/glib-2.26
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

if [[ -z ${EGIT_COMMIT} ]]; then
	SRC_URI="mirror://gnome/sources/${PN}/$(get_version_component_range 1-2)/${P}.tar.xz"
else
	DEPEND+=" dev-util/gtk-doc dev-util/intltool"
fi

src_prepare() {
	if [[ -n ${EGIT_COMMIT} ]]; then
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
