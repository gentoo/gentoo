# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Profiling and leak detection tool"
HOMEPAGE="https://www.secretlabs.de/projects/memprof/"
SRC_URI="https://www.secretlabs.de/projects/memprof/releases/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	>=gnome-base/libglade-2
	>=x11-libs/gtk+-2.6:2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)"

PATCHES=(
	"${FILESDIR}"/${P}-binutils.patch
	"${FILESDIR}"/${P}-desktop.patch
	"${FILESDIR}"/${P}-gcc14-build-fix.patch
)

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
