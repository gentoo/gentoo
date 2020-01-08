# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A GTK theme to match Enlightenment WM's default theme"
HOMEPAGE="https://gitlab.com/tokiclover/e-gtk-theme"
SRC_URI="https://gitlab.com/tokiclover/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare() {
	default
	find . -name 'Makefile' -delete || die
}

src_install() {
	insinto /usr/share/themes/e-gtk-theme
	doins -r apps/ gtk-2.0/ gtk-3.0/ metacity-1/ openbox-3/ index.theme start-here.png

	einstalldocs
}
