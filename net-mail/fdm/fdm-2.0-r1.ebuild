# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="fetch, filter and deliver mail"
HOMEPAGE="https://github.com/nicm/fdm"
SRC_URI="https://github.com/nicm/fdm/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="examples pcre"

DEPEND="
	dev-libs/openssl:0=
	sys-libs/tdb
	pcre? ( dev-libs/libpcre )
"
RDEPEND="
	${DEPEND}
	acct-group/fdm
	acct-user/fdm
"

DOCS=( CHANGES README TODO MANUAL )

src_prepare() {
	default

	# Change user '_fdm' to 'fdm'
	sed -e 's/_fdm/fdm/g' -i fdm.h || die
}

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
