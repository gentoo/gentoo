# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A Qt wrapper for libolm."
HOMEPAGE="https://gitlab.com/b0/libqtolm"
SRC_URI="https://gitlab.com/b0/libqtolm/-/archive/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-qt/qtcore-5.9
>=net-libs/olm-3.2.1"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/libqtolm-v${PV}-750ae3abbab223d93e48e9f84a1db05d1919f6ca" "${WORKDIR}/${P}"
}
