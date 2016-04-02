# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="X11 operating system viewer"
HOMEPAGE="http://www.pogo.org.uk/~mark/xosview/"
SRC_URI="http://www.pogo.org.uk/~mark/${PN}/releases/${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"
IUSE="suid"

COMMON_DEPS="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXt"
RDEPEND="${COMMON_DEPS}
	media-fonts/font-misc-misc"
DEPEND="${COMMON_DEPS}
	x11-proto/xproto"

src_prepare() {
	sed -i -e 's:lib/X11/app:share/X11/app:g' -i ${PN}.1 || die
	sed -i -e "s:Git:${PV}:g" ${PN}.cc || die
	tc-export CXX
}

src_compile() {
	emake OPTFLAGS=''
}

src_install() {
	dobin ${PN}
	use suid && fperms 4755 /usr/bin/${PN}
	insinto /usr/share/X11/app-defaults
	newins Xdefaults XOsview
	doman *.1
	dodoc CHANGES README.linux TODO
}

pkg_postinst() {
	if ! use suid ; then
		ewarn "If you want to use serial meters ${PN} needs to be executed as root."
		ewarn "Please see ${EPREFIX}/usr/share/doc/${PF}/README.linux for details."
	fi
}
