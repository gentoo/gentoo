# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

MY_P="lazarus-3.0-0"

DESCRIPTION="Free Pascal Qt6 bindings library updated by lazarus IDE."
HOMEPAGE="https://gitlab.com/freepascal.org/lazarus/lazarus"
SRC_URI="mirror://sourceforge/lazarus/${MY_P}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="LGPL-3"
SLOT="0/2.2"

DEPEND="
	dev-qt/qtbase:6
"

S="${WORKDIR}/lazarus/lcl/interfaces/qt6/cbindings"

src_configure() {
	eqmake6 Qt6Pas.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
