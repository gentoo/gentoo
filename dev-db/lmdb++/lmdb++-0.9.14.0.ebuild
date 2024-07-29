# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/lmdb++/lmdbxx}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="C++11 wrapper for the LMDB database library"
HOMEPAGE="http://lmdbxx.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/lmdbxx/${PV}/${MY_P}.tar.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-db/lmdb"

src_install() {
	emake PREFIX="${D}/usr" install
	dodoc AUTHORS CREDITS INSTALL README TODO UNLICENSE
}
