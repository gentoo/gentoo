# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_P="skk${PV}mu"

DESCRIPTION="Dictionary server for the SKK Japanese-input software"
HOMEPAGE="http://openlab.ring.gr.jp/skk/"
SRC_URI="http://openlab.ring.gr.jp/skk/maintrunk/museum/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="app-i18n/skk-jisyo"
S="${WORKDIR}/skk-${PV}mu"

PATCHES=(
	"${FILESDIR}"/${PN}-segfault.patch
	"${FILESDIR}"/${PN}-headers.patch
	"${FILESDIR}"/${PN}-suffix.patch
)

src_compile() {
	emake -C ${PN}
}

src_install() {
	dosbin ${PN}/${PN}

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}
