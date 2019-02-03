# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2

DESCRIPTION="Modern multi-purpose calculator"
HOMEPAGE="https://qalculate.github.io/"
SRC_URI="https://github.com/Qalculate/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-libs/glib:2
	>=sci-libs/libqalculate-2.8.1:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}
	app-text/rarian
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-2.8.1-entry.patch"
)

src_prepare() {
	# Required by src_test() and `make check`
	echo data/calendarconversion.ui > po/POTFILES.skip || die
	echo data/periodictable.ui >> po/POTFILES.skip || die

	gnome2_src_prepare
}
