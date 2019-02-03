# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools gnome2 mono-env

DESCRIPTION="GTK# Hex Editor"
HOMEPAGE="https://github.com/bwrsandman/Bless/"
SRC_URI="https://dev.gentoo.org/~ikelos/devoverlay-distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	>=dev-lang/mono-1.1.14
	>=dev-dotnet/gtk-sharp-2.12.21:2
"
DEPEND="${RDEPEND}
	app-text/rarian
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

	mono-env_pkg_setup
}

src_prepare() {
	einfo "Running gettextize -f --no-changelog..."
	( "${T}/gettextize" -f --no-changelog > /dev/null ) || die "gettexize failed"
	eapply "${FILESDIR}/${P}-pixmap.patch"
	eapply "${FILESDIR}/${P}-docpath.patch"
	eapply "${FILESDIR}/${P}-mono-4.patch"
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-unix-specific \
		$(use_enable debug)
}
