# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg-utils

DESCRIPTION="A graphical user interface for Fritz!Box routers to send fax, retrieve call lists, make calls and access the address book."
HOMEPAGE="https://tabos.gitlab.io/project/rogerrouter/"

SRC_URI="https://gitlab.com/tabos/rogerrouter/-/archive/v${PV}/rogerrouter-v${PV}.tar.bz2 -> ${P}.tar.bz2"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	x11-libs/gtk+:3
	net-libs/libsoup:2.4
	media-libs/tiff
	dev-libs/libappindicator:3
	app-text/libebook
	dev-libs/libgdata
	net-libs/librm"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-gsettings-crashes.patch"
)

src_unpack() {
	unpack ${A}
	mv rogerrouter-v${PV} ${PN}-${PV}
}
