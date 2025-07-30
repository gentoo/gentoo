# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="(T)he k(I)cki(N) (T)ickin d(I)kumud clie(N)t"
HOMEPAGE="https://tintin.mudhalla.net/"
SRC_URI="https://github.com/scandum/${PN}/releases/download/${PV}/${P}.tar.gz"
S="${WORKDIR}"/tt/src

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/libpcre:3
	net-libs/gnutls:=
	sys-libs/readline:=
	sys-libs/zlib
"

RDEPEND="
	${DEPEND}
"

src_install() {
	dobin tt++
	dodoc ../{CREDITS,FAQ,README,SCRIPTS,TODO,docs/*}
}

pkg_postinst() {
	ewarn "**** OLD TINTIN SCRIPTS ARE NOT 100% COMPATIBLE WITH THIS VERSION ****"
	ewarn "read the README for more details."
}
