# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson vcs-snapshot
COMMIT="21a55145ddbc5d085e91352586875abe92cff73b"

DESCRIPTION="An ncurses UI for connman, forked from connman-json-client"
HOMEPAGE="https://github.com/l4rzy/ncman"
SRC_URI="https://github.com/l4rzy/ncman/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/json-c:0=
	>=sys-apps/dbus-1.4
	sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
