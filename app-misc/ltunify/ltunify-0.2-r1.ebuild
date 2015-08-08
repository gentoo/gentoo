# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs udev

DESCRIPTION="Tool for working with Logitech Unifying receivers and devices"
HOMEPAGE="https://lekensteyn.nl/logitech-unifying.html https://git.lekensteyn.nl/ltunify/"
SRC_URI="https://git.lekensteyn.nl/${PN}/snapshot/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	sed -i '/^override CFLAGS/d' Makefile || die

	# allow plugdev group r/w access
	sed -i 's/^#MODE=/MODE=/' udev/42-logitech-unify-permissions.rules || die

	tc-export CC
}

src_compile() {
	emake ${PN}
}

src_install() {
	dobin ${PN}
	dodoc NEWS README.txt

	# avoid file collision with solaar
	udev_newrules udev/42-logitech-unify-permissions.rules 42-logitech-unify-${PN}.rules
}
