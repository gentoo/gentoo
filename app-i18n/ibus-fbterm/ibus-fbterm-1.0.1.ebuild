# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="IBus client for FbTerm"
HOMEPAGE="https://github.com/fujiwarat/ibus-fbterm"
SRC_URI="https://github.com/fujiwarat/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-i18n/ibus
	app-i18n/fbterm
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
