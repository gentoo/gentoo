# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="DataStax C/C++ Driver for Cassandra"
HOMEPAGE="https://datastax.github.io/cpp-driver/"
SRC_URI="https://github.com/datastax/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl ssl"

RDEPEND="
	dev-libs/libuv:=
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=( -DCASS_USE_OPENSSL=$(usex ssl) )
	cmake-utils_src_configure
}
