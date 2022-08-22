# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_IN_SOURCE_BUILD=1
inherit cmake

DESCRIPTION="S/MIME signing milter"
HOMEPAGE="https://signing-milter.org/"
SRC_URI="https://github.com/croessner/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/sigh
	acct-user/sigh
	dev-libs/boost
	dev-libs/openssl:0=
	mail-filter/libmilter:="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_install() {
	cmake_src_install
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}
