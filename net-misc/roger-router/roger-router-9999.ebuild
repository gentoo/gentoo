# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg-utils

DESCRIPTION="A graphical user interface for Fritz!Box routers."
HOMEPAGE="https://tabos.gitlab.io/project/rogerrouter/"

inherit git-r3
EGIT_REPO_URI="https://gitlab.com/tabos/rogerrouter.git"
KEYWORDS=""

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	x11-libs/gtk+:3
	net-libs/libsoup:2.4
	media-libs/tiff
	dev-libs/libappindicator:3
	app-text/libebook
	dev-libs/libgdata
	gui-libs/libhandy
	~net-libs/librm-9999"
DEPEND="${RDEPEND}"
