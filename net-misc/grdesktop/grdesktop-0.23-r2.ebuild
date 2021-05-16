# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"
inherit gnome2

DESCRIPTION="Gtk3 frontend for rdesktop"
HOMEPAGE="http://www.nongnu.org/grdesktop/"
SRC_URI="https://savannah.nongnu.org/download/${PN}/${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${P}-patchset.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="
	>=x11-libs/gtk+-3.21.4:3
	net-misc/rdesktop
"
DEPEND="${RDEPEND}
	app-text/rarian
	virtual/pkgconfig
"

PATCHES=(
	# Patches from debian:
	# Correct icon path. See bug #50295.
	# Fix compilation with format-security, bug #517662
	# gsettings, gtk3 port, gcc10 compat, etc
	"${WORKDIR}"/grdesktop-0.23+d040330-7
)

src_prepare() {
	gnome2_src_prepare
	# Fix desktop file validation after debian patchset (it removes Action line, but not the action itself - remove that here)
	sed -e '/Desktop Action Full/,+1d' -i grdesktop.desktop
}

src_configure() {
	gnome2_src_configure \
		--with-keymap-path=/usr/share/rdesktop/keymaps/
}
