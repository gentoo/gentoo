# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/lmdb++/lmdbxx}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="C++11 wrapper for the LMDB database library"
HOMEPAGE="https://github.com/hoytech/lmdbxx"
SRC_URI="https://github.com/hoytech/lmdbxx/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-db/lmdb"

src_install() {
	emake PREFIX="${D}/usr" install
	dodoc AUTHORS CREDITS INSTALL README.md TODO UNLICENSE
}

src_test() {
	emake CXXFLAGS="-g -std=c++17 ${CXXFLAGS}" LDFLAGS="${LDFLAGS}" check
}
