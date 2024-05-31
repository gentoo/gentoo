# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="GTK+ based Audio CD Player/Ripper"
HOMEPAGE="https://sourceforge.net/projects/grip/"
SRC_URI="https://downloads.sourceforge.net/grip/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ppc ppc64 sparc ~x86"
IUSE="vorbis"

# lame and vorbis-tools are no real RDEPENDs. But without them
# grip cannot convert ripped files to any format. So use them as
# a sane default.
RDEPEND="
	!app-text/grip
	dev-libs/glib:2
	media-libs/id3lib
	>=media-sound/cdparanoia-3.10.2-r8
	media-sound/lame
	net-misc/curl
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/pango
	vorbis? ( media-sound/vorbis-tools )
"
# gnome-extra/yelp, see bug #416843
DEPEND="
	${RDEPEND}
	sys-devel/gettext
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dcdparanoia=enabled
		-Did3lib=enabled
	)

	meson_src_configure
}
