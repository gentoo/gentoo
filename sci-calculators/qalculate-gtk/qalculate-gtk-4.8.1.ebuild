# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: bump with sci-libs/libqalculate and sci-calculators/qalculate-qt!

inherit xdg

DESCRIPTION="Modern multi-purpose calculator"
HOMEPAGE="https://qalculate.github.io/"
SRC_URI="https://github.com/Qalculate/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-libs/glib:2
	>=sci-libs/libqalculate-${PV}:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/gdbus-codegen
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	# Required by src_test() and `make check`
	cat >po/POTFILES.skip <<-EOF || die
		# Required by make check
		data/calendarconversion.ui
		data/periodictable.ui
	EOF

	default
}
