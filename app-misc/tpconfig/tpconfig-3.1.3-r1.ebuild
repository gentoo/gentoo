# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit toolchain-funcs

DESCRIPTION="Touchpad config for ALPS and Synaptics TPs. Controls tap/click behaviour"
HOMEPAGE="http://www.compass.com/synaptics/"
SRC_URI="http://www.compass.com/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

src_compile() {
	econf
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin tpconfig || die "dobin failed!"
	dodoc README AUTHORS NEWS INSTALL
	doinitd "${FILESDIR}"/tpconfig
	newconfd "${FILESDIR}"/tpconfig.conf tpconfig
}
