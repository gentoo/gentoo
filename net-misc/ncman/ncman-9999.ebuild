# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson git-r3
COMMIT="bca0dc0a835f8a267be28d32b49775a50543d081"

DESCRIPTION="An ncurses UI for connman, forked from connman-json-client"
HOMEPAGE="https://github.com/l4rzy/ncman"
EGIT_REPO_URI=https://github.com/l4rzy/ncman.git

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/json-c:0=
	>=sys-apps/dbus-1.4
	sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
