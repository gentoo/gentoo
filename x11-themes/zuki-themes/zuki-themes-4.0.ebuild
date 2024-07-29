# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Zuki themes for GTK, gnome-shell and more"
HOMEPAGE="https://github.com/lassekongo83/zuki-themes"
SRC_URI="https://github.com/lassekongo83/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome-shell gtk2 xfce"

DEPEND=""
RDEPEND="
	>=x11-themes/gnome-themes-standard-3.6
	gtk2? ( >=x11-themes/gtk-engines-murrine-0.98.1.1 )
"
BDEPEND="dev-lang/sassc"

src_install() {
	meson_src_install

	if ! use gnome-shell; then
		rm -r "${ED}"/usr/share/themes/Zuki-shell || die
	fi

	if ! use gtk2; then
		rm -r "${ED}"/usr/share/themes/*/gtk-2.0 || die
	fi

	if ! use xfce; then
		rm -r "${ED}"/usr/share/themes/*/xfwm4 || die
	fi
}
