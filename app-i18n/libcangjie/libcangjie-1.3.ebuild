# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Library implementing the Cangjie input method"
HOMEPAGE="http://cangjians.github.io/"
SRC_URI="https://github.com/Cangjians/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-db/sqlite:3="
DEPEND="${RDEPEND}"
