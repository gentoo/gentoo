# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/lcab/lcab-1.0_beta12.ebuild,v 1.2 2012/12/17 06:26:44 binki Exp $

EAPI="4"

inherit autotools

MY_PV=${PV/_beta/b}
MY_P=${PN}-${MY_PV}

DESCRIPTION="CAB file creation tool"
HOMEPAGE="http://ohnopub.net/lcab/"
SRC_URI="ftp://mirror.ohnopub.net/mirror/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i "s:1.0b11:${MY_PV}:" mytypes.h || die
	eautoreconf
}

src_install() {
	default
	doman ${PN}.1
}
