# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A modern flat theme with a combination of light and dark elements"
HOMEPAGE="https://github.com/numixproject/numix-gtk-theme"
SRC_URI="https://github.com/numixproject/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/libxml2:2
	x11-libs/gtk+:3
	x11-themes/gtk-engines-murrine"
DEPEND="${RDEPEND}
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2"
BDEPEND="dev-lang/sassc"

PATCHES=( "${FILESDIR}/${P}-replace-ruby-sassc-with-dev-lang-sassc.patch" )
