# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Graphical tool to show free disk space like df"
HOMEPAGE="https://gitlab.com/mazes_80/gtkdiskfree"
COMMIT="bdda379b9109a226a37801505a19da91494144a6"
SRC_URI="https://gitlab.com/mazes_80/${PN}/-/archive/${COMMIT}/${PN}-${COMMIT}.tar.bz2"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	dev-libs/glib
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.4-musl-setlocale.patch
	"${FILESDIR}"/${PN}-2.0.4-use-const-data-for-icon.patch
)

src_configure() {
	econf --enable-old-color-selector
}
