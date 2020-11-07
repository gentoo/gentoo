# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A Qt5 library to write cross-platform clients for Matrix"
HOMEPAGE="https://github.com/quotient-im/libQuotient"
SRC_URI="https://github.com/quotient-im/libQuotient/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="-end2end"

RDEPEND=">=dev-qt/qtnetwork-5.9
>=dev-qt/qtcore-5.9
>=dev-qt/qtgui-5.9
end2end? ( >=dev-libs/libqtolm-3.0.1 )"
