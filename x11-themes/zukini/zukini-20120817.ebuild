# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Unified look for GTK+ 2.x, GTK+ 3.x, gnome-shell, metacity and more"
HOMEPAGE="http://lassekongo83.deviantart.com/#/d4ic1u2"
SRC_URI="https://dev.gentoo.org/~sping/distfiles/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

RESTRICT="binchecks strip"

BDEPEND="app-arch/unzip"
RDEPEND=">=x11-themes/gtk-engines-murrine-0.98.2
	>=x11-themes/gtk-engines-unico-1.0.2"

S=${WORKDIR}

src_unpack() {
	unpack ${A}

	local x=${S}/Zukini-awn
	mkdir -p "${x}" || die
	tar -zxf Zukini-awn.tgz -C "${x}" || die
}

src_install() {
	insinto /usr/share/themes
	doins -r Zukini

	dodoc -r INSTALL panelbg.png README Zukini-awn # Yes, we want INSTALL!
}
