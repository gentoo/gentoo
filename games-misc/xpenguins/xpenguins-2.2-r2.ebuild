# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

THEMES_VERSION="1.0"
DESCRIPTION="Cute little penguins invading your desktop"
HOMEPAGE="http://xpenguins.seul.org/"
SRC_URI="http://xpenguins.seul.org/${P}.tar.gz
	http://xpenguins.seul.org/xpenguins_themes-${THEMES_VERSION}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_install() {
	default
	insinto /usr/share/${PN}
	doins -r ../themes/
}
