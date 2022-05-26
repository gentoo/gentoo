# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="Crawls through your online content"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeOnlineMiners"
SRC_URI="${SRC_URI}
	https://src.fedoraproject.org/rpms/gnome-online-miners/raw/f36/f/tracker3.patch -> ${P}-tracker3.patch"

LICENSE="GPL-2+"
SLOT="0"
IUSE="flickr"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

# libgdata[gnome] needed for goa support
RDEPEND="
	app-misc/tracker:3=
	>=dev-libs/glib-2.56.0:2
	>=dev-libs/libgdata-0.15.2:0=[crypt,gnome-online-accounts]
	media-libs/grilo:0.3
	>=net-libs/gnome-online-accounts-3.13.3:=
	>=net-libs/libgfbgraph-0.2.2:0.2
	>=net-libs/libzapojit-0.0.2
	flickr? ( media-plugins/grilo-plugins:0.3[flickr] )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# From Fedora, waiting to be accepted by upstream
	# https://gitlab.gnome.org/GNOME/gnome-online-miners/-/merge_requests/3
	"${DISTDIR}/${P}-tracker3.patch"
)

src_configure() {
	gnome2_src_configure \
		$(use_enable flickr) \
		--disable-static \
		--enable-facebook \
		--enable-google \
		--enable-media-server \
		--enable-owncloud \
		--enable-windows-live
}
