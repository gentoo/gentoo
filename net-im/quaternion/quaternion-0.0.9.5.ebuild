# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PV="${PV}-beta2"

DESCRIPTION="A Qt5-based IM client for Matrix"
HOMEPAGE="https://github.com/quotient-im/Quaternion"
SRC_URI="https://github.com/quotient-im/Quaternion/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="-end2end"

RDEPEND=">=net-libs/libQuotient-0.6.2[end2end?]
>=dev-qt/qtdeclarative-5.9
>=dev-qt/qtquickcontrols-5.9
>=dev-qt/qtquickcontrols2-5.9
>=dev-qt/qtmultimedia-5.9
end2end? ( >=dev-libs/qtkeychain-0.10.0 )"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/Quaternion-${MY_PV}" "${WORKDIR}/${P}"
}
