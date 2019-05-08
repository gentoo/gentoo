# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

KEYWORDS="~amd64 ~arm ~ppc ~x86"

DESCRIPTION="A simple CLI program for displaying network statistics in real time"
HOMEPAGE="http://ifstatus.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-v${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=sys-libs/ncurses-4.2:0=
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.0.0-tinfo.patch
)
S="${WORKDIR}/${PN}-v${PV}"

src_compile() {
	tc-export CXX PKG_CONFIG
	emake GCC=$(tc-getCXX) ${PN}
}

src_install() {
	dobin ifstatus
	dodoc AUTHORS README
}

pkg_postinst() {
	elog	"You may want to configure ~/.ifstatus/ifstatus.cfg"
	elog	"before running ifstatus. For example, you may add"
	elog	"Interfaces = eth0 there. Read the README file for"
	elog	"more information."
}
