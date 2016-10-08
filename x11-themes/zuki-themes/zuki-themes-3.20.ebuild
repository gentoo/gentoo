# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PV="${PV}-1"
DESCRIPTION="Zuki themes for GTK, gnome-shell and more"
HOMEPAGE="http://gnome-look.org/content/show.php/Zukitwo?content=140562"
SRC_URI="https://github.com/lassekongo83/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome-shell mate xfce"

RDEPEND="
	>=x11-themes/gnome-themes-standard-3.6
	>=x11-themes/gtk-engines-murrine-0.98.1.1
	gnome-shell? ( media-fonts/roboto )
	!<x11-themes/zukitwo-2016.08.08
	!<x11-themes/zukitwo-shell-2016.08.08
"
DEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /usr/share/themes/Zukitre
	doins -r Zukitre/{index.theme,gtk-2.0,gtk-3.0}
	use xfce && doins -r Zukitre/xfwm4

	insinto /usr/share/themes/Zukitwo
	doins -r Zukitwo/{index.theme,gtk-2.0,gtk-3.0}
	use mate && doins -r Zukitwo/metacity-1
	use xfce && doins -r Zukitwo/xfwm4

	if use gnome-shell ; then
		insinto /usr/share/themes
		doins -r Zuki-shell
	fi

	default
}
