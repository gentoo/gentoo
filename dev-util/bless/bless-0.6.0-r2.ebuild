# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"

inherit autotools eutils gnome2 mono-env

DESCRIPTION="GTK# Hex Editor"
HOMEPAGE="http://home.gna.org/bless/"
SRC_URI="http://download.gna.org/bless/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	>=dev-lang/mono-1.1.14
	>=dev-dotnet/gtk-sharp-2.12
	|| ( >=dev-dotnet/gtk-sharp-2.12.21
	     >=dev-dotnet/glade-sharp-2.12 )
"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=sys-devel/gettext-0.15
	virtual/pkgconfig
"

# See bug 278162
# Waiting on nunit ebuild entering the tree
RESTRICT="test"

pkg_setup() {
	# Stolen from enlightenment.eclass
	cp $(type -p gettextize) "${T}/" || die "Could not copy gettextize"
	sed -i -e 's:read dummy < /dev/tty::' "${T}/gettextize"
}

src_prepare() {
	einfo "Running gettextize -f --no-changelog..."
	( "${T}/gettextize" -f --no-changelog > /dev/null ) || die "gettexize failed"
	epatch "${FILESDIR}/${P}-pixmap.patch"
	epatch "${FILESDIR}/${P}-docpath.patch"
	epatch "${FILESDIR}/${P}-mono-4.patch"
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-unix-specific \
		$(use_enable debug)
}
