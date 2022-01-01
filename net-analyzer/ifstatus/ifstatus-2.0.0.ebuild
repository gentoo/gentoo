# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A simple CLI program for displaying network statistics in real time"
HOMEPAGE="http://ifstatus.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-v${PV}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~ppc x86"

RDEPEND=">=sys-libs/ncurses-4.2:0="
DEPEND="${RDEPEND}"
BDEPEND+"virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.0-tinfo.patch
)

src_compile() {
	tc-export CXX PKG_CONFIG
	emake GCC="$(tc-getCXX)" ${PN}
}

src_install() {
	dobin ifstatus
	dodoc AUTHORS README
}

pkg_postinst() {
	elog "You may want to configure ~/.ifstatus/ifstatus.cfg"
	elog "before running ifstatus. For example, you may add"
	elog "Interfaces = eth0 there. Read the README file for"
	elog "more information."
}
