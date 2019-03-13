# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop

DESCRIPTION="Documentation API reference for Cantera package libraries"
HOMEPAGE="https://cantera.org"
SRC_URI="https://github.com/band-a-prend/gentoo-overlay/releases/download/ct-docs-${PV}/${P}_modified_menu.tar.xz -> ${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-misc/xdg-utils
"

S="${WORKDIR}/"

src_install() {
	insinto /usr/share/cantera/doc/
	doins -r "${S}/."

	make_desktop_entry "/usr/bin/xdg-open /usr/share/cantera/doc/doxygen/html/index.html" "Cantera Doxygen Documentation" "text-html" "Development"
	make_desktop_entry "/usr/bin/xdg-open /usr/share/cantera/doc/sphinx/html/index.html" "Cantera Sphinx Documentation" "text-html" "Development"
}
