# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/lmdb++/lmdbxx}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="C++11 wrapper for the LMDB database library"
HOMEPAGE="https://github.com/hoytech/lmdbxx"
SRC_URI="https://github.com/hoytech/lmdbxx/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-db/lmdb"

src_install() {
	emake PREFIX="${D}/usr" install
	dodoc AUTHORS CREDITS INSTALL README.md TODO UNLICENSE
}
