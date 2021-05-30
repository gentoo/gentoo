# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools xdg

DESCRIPTION="AppIndicator/KStatusNotifierItem plugin for Pidgin"
HOMEPAGE="https://github.com/philipl/pidgin-indicator"
SRC_URI="https://github.com/philipl/pidgin-indicator/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# No direct gtk3 until pidgin migrates:
# https://github.com/philipl/pidgin-indicator/issues/32
RDEPEND="
	dev-libs/libappindicator:3
	net-im/pidgin[gtk]
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}
	dev-perl/XML-Parser
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-appindicator3.patch"
)

src_prepare() {
	xdg_src_prepare
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die "Pruning failed"
}
