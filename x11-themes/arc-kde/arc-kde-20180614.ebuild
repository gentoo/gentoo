# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Port of the popular GTK theme Arc for Plasma 5"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/arc-kde"
SRC_URI="https://github.com/PapirusDevelopmentTeam/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""

pkg_postinst() {
	elog ""
	elog "This theme optionally supports \"x11-themes/kvantum\""
	elog "See also \"x11-themes/arc-theme\" for gtk support"
	elog ""
}
