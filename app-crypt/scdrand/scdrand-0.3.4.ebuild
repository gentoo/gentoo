# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=scdtools-${PV}
DESCRIPTION="Feed kernel entropy pool from smartcard's TRNG"
HOMEPAGE="https://incenp.org/dvlpt/scdtools.html"
SRC_URI="https://incenp.org/files/softs/scdtools/$(ver_cut 1-2)/${MY_P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libgcrypt:=
	dev-libs/libassuan:=
	dev-libs/libgpg-error:="
RDEPEND="${DEPEND}
	app-crypt/gnupg"

S=${WORKDIR}/${MY_P}

src_compile() {
	emake -C lib
	emake -C src scdrand
}

src_test() { :; }

src_install() {
	emake DESTDIR="${D}" -C man man_MANS="scdrand.1" install
	emake DESTDIR="${D}" -C src bin_PROGRAMS="scdrand" install
}
