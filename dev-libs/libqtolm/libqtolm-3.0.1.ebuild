# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt wrapper for libolm"
HOMEPAGE="https://gitlab.com/b0-matrix/libqtolm"
SRC_URI="https://gitlab.com/b0-matrix/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/olm
	dev-qt/qtcore:5
"
RDEPEND="${DEPEND}"
