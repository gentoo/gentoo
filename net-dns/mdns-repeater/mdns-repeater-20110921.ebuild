# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Multicast DNS repeater"
HOMEPAGE="https://bitbucket.org/geekman/mdns-repeater/"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm"

REV="28ecc2ab9a0e"
SRC_URI="https://bitbucket.org/geekman/mdns-repeater/get/${REV}.tar.gz -> ${PN}-${REV}.tar.gz"
S="${WORKDIR}/geekman-mdns-repeater-${REV}"

src_configure() {
	tc-export CC
}

src_compile() {
	emake HGVERSION="${REV}"
}

src_install() {
	dobin "${PN}"
}
