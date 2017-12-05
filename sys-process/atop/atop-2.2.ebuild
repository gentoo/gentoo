# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils toolchain-funcs systemd

MY_PV=${PV//_p/-}
MY_P=${PN}-${MY_PV}-3

DESCRIPTION="Resource-specific view of processes"
HOMEPAGE="https://www.atoptool.nl/"
SRC_URI="https://www.atoptool.nl/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	sys-libs/ncurses
	sys-process/acct
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.2-build.patch
	epatch "${FILESDIR}"/${PN}-2.2-sysmacros.patch #580372
	tc-export CC PKG_CONFIG
	sed -i 's: root : :' atop.cronsysv || die #191926
	# prefixify
	sed -i "s:/\(usr\|etc\|var\):${EPREFIX}/\1:g" Makefile
}

src_install() {
	emake DESTDIR="${D}" genericinstall
	# useless -${PV} copies ?
	rm -f "${ED}"/usr/bin/atop*-${MY_PV}
	newinitd "${FILESDIR}"/${PN}.rc-r1 ${PN}
	newinitd "${FILESDIR}"/atopacct.rc atopacct
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_dounit "${FILESDIR}"/atopacct.service
	dodoc atop.cronsysv AUTHOR ChangeLog README
}
