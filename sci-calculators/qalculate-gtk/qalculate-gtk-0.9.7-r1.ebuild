# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG=no
inherit eutils gnome2

DESCRIPTION="Modern multi-purpose calculator"
HOMEPAGE="http://qalculate.sourceforge.net/"
SRC_URI="mirror://sourceforge/qalculate/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="gnome"

RDEPEND=">=sci-libs/libqalculate-0.9.7
	>=sci-libs/cln-1.2
	x11-libs/gtk+:2
	gnome-base/libglade:2.0
	gnome? ( >=gnome-base/libgnome-2 )"
DEPEND="${RDEPEND}
	app-text/rarian
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-entry.patch"
	"${FILESDIR}/${P}-wformat-security.patch"
)
DOCS="AUTHORS ChangeLog NEWS README TODO"

src_prepare() {
	# Required by src_test() and `make check`
	echo data/periodictable.glade > po/POTFILES.skip || die
	epatch -p1 "${PATCHES[@]}"
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure $(use_with gnome libgnome)
}
