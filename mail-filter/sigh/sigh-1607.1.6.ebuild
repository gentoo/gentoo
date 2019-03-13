# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils user

DESCRIPTION="S/MIME signing milter"
HOMEPAGE="https://signing-milter.org/"
SRC_URI="https://github.com/croessner/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="mail-filter/libmilter
	dev-libs/boost
	dev-libs/openssl:0"
DEPEND="${RDEPEND}"

DOCS=( README README.build AUTHORS LICENSE )
CMAKE_IN_SOURCE_BUILD=1

pkg_setup() {
	enewgroup sigh
	enewuser sigh -1 -1 /var/lib/sigh sigh
}

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	dodoc "${DOCS[@]}"

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}
