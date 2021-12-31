# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION="PEM file reader for Network Security Services (NSS)"
HOMEPAGE="https://github.com/kdudka/nss-pem"
SRC_URI="https://github.com/kdudka/${PN}/releases/download/${P}/${P}.tar.xz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

BDEPEND=" >=dev-libs/nss-3.50-r1 "
RDEPEND="${BDEPEND}"

DEPEND="!<=dev-libs/nss-3.50
	${RDEPEND}"

S="${WORKDIR}/${P}/src"
