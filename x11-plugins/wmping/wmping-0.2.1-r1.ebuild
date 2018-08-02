# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="a simple host status monitoring dockapp"
HOMEPAGE="https://sourceforge.net/projects/wmping"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+suid"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libICE
	x11-libs/libXt"

PATCHES=( "${FILESDIR}"/${P}-format-security.patch )

DOCS=( AUTHORS CHANGES README )

src_install() {
	if use suid; then
		default
	else
		dosbin ${PN}
		einstalldocs
	fi
	doman ${PN}.1
}

pkg_postinst() {
	use suid || ewarn "warning, ${PN} needs to be executed as root."
}
