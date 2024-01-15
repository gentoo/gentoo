# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="An analog clock displaying the system-time"
HOMEPAGE="https://launchpad.net/cairo-clock"
SRC_URI="http://macslow.thepimp.net/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=dev-libs/glib-2.8
	>=gnome-base/libglade-2.6
	>=gnome-base/librsvg-2.14
	>=x11-libs/cairo-1.2
	>=x11-libs/gtk+-2.10:2
	>=x11-libs/pango-1.10
"
DEPEND="${RDEPEND}"
# autoconf-archive for F_S patch
BDEPEND="
	dev-util/intltool
	dev-build/autoconf-archive
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-desktop.patch
	"${FILESDIR}"/${P}-linker.patch
	"${FILESDIR}"/${P}-fortify-source.patch
)

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	gzip -d "${ED}"/usr/share/man/man1/cairo-clock.1.gz || die
}
