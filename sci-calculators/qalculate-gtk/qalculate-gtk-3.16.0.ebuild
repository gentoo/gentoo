# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2

DESCRIPTION="Modern multi-purpose calculator"
HOMEPAGE="https://qalculate.github.io/"
SRC_URI="https://github.com/Qalculate/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ppc sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-libs/glib:2
	>=sci-libs/libqalculate-3.16.0:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/rarian
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	# Required by src_test() and `make check`
	echo data/calendarconversion.ui > po/POTFILES.skip || die
	echo data/periodictable.ui >> po/POTFILES.skip || die

	gnome2_src_prepare
}
