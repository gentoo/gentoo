# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs xdg-utils

DESCRIPTION="X11 operating system viewer"
HOMEPAGE="http://www.pogo.org.uk/~mark/xosview/"
SRC_URI="http://www.pogo.org.uk/~mark/${PN}/releases/${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="suid"

COMMON_DEPS="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXt"
RDEPEND="${COMMON_DEPS}
	media-fonts/font-misc-misc"
DEPEND="${COMMON_DEPS}
	x11-base/xorg-proto"

DOCS=( CHANGES README.linux TODO )

src_prepare() {
	default

	sed -i -e 's:lib/X11/app:share/X11/app:g' -i ${PN}.1 || die
	sed -i -e "s:Git:${PV}:g" ${PN}.cc || die
	tc-export CXX
}

src_compile() {
	emake OPTFLAGS=''
}

src_install() {
	emake PREFIX="${D%/}/usr" install
	use suid && fperms 4755 /usr/bin/${PN}
	insinto /usr/share/X11/app-defaults
	newins Xdefaults XOsview
}

pkg_postinst() {
	xdg_desktop_database_update

	if ! use suid ; then
		ewarn "If you want to use serial meters ${PN} needs to be executed as root."
		ewarn "Please see ${EPREFIX}/usr/share/doc/${PF}/README.linux for details."
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
}
