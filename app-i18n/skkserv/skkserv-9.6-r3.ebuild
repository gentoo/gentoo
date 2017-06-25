# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=3
inherit eutils

MY_P="skk${PV}mu"

DESCRIPTION="Dictionary server for the SKK Japanese-input software"
HOMEPAGE="http://openlab.ring.gr.jp/skk/"
SRC_URI="http://openlab.ring.gr.jp/skk/maintrunk/museum/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=">=app-i18n/skk-jisyo-200210"

S="${WORKDIR}/skk-${PV}mu"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-segfault.patch
	epatch "${FILESDIR}"/${PN}-headers.patch
}

src_configure() {
	econf --libexecdir="${EPREFIX}"/usr/sbin
}

src_compile() {
	cd skkserv
	emake || die
}

src_install() {
	cd skkserv
	dosbin skkserv || die

	newinitd "${FILESDIR}"/skkserv.initd skkserv
}
