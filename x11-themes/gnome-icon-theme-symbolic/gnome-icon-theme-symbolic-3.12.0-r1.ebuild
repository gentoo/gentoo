# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="Symbolic icons for GNOME default icon theme"
HOMEPAGE="https://gitlab.gnome.org/Archive/gnome-icon-theme-symbolic"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
# This ebuild does not install any binaries
RESTRICT="binchecks strip"

# keyboard-brightness icon file collision with old gnome-power-manager
DEPEND=">=x11-themes/hicolor-icon-theme-0.10"
# gnome-base/librsvg will be needed by apps using this icons, bug #508210
RDEPEND="${DEPEND}
	gnome-base/librsvg
	!=gnome-extra/gnome-power-manager-3.0*"
BDEPEND="
	>=x11-misc/icon-naming-utils-0.8.7
	virtual/pkgconfig"

src_configure() {
	gnome2_src_configure \
		--enable-icon-mapping \
		GTK_UPDATE_ICON_CACHE=$(type -P true)
}
