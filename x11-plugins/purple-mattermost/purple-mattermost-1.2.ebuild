# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A libpurple/Pidgin plugin for Mattermost"
HOMEPAGE="https://github.com/EionRobb/purple-mattermost"
SRC_URI="https://github.com/EionRobb/purple-mattermost/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-text/discount
	dev-libs/glib
	dev-libs/json-glib
	net-im/pidgin"
DEPEND="${RDEPEND}"

src_compile() {
	emake CC="$(tc-getCC)"
}
