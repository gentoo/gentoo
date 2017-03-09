# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2

DESCRIPTION="Modern multi-purpose calculator"
HOMEPAGE="https://qalculate.github.io/"
SRC_URI="https://github.com/Qalculate/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86 ~amd64-linux ~x86-linux"
IUSE="gnome"

RDEPEND=">=sci-libs/libqalculate-0.9.9:=
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	app-text/rarian
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-0.9.9-entry.patch"
)

src_prepare() {
	# Required by src_test() and `make check`
	echo data/periodictable.ui > po/POTFILES.skip || die

	gnome2_src_prepare
}
