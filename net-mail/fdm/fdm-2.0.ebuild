# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

DESCRIPTION="fetch, filter and deliver mail"
HOMEPAGE="https://github.com/nicm/fdm"
SRC_URI="https://github.com/nicm/fdm/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples libressl pcre"

DEPEND="!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-libs/tdb
	pcre? ( dev-libs/libpcre )"
RDEPEND="${DEPEND}"

DOCS=( CHANGES README TODO MANUAL )

src_configure() {
	econf $(use_enable pcre)
}

src_install() {
	default

	if use examples ; then
		docinto examples
		dodoc examples/*
	fi
}

pkg_preinst() {
	# This user is hard-coded in fdm.h. If fdm is started as root,
	# it will attempt to drop privileges (to this user).
	enewuser _fdm
}
