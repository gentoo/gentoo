# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_P="TkPasMan-${PV}"

DESCRIPTION="A useful and reliable personal password manager, written in Tcl/Tk"
HOMEPAGE="http://www.xs4all.nl/~wbsoft/linux/tkpasman.html"
SRC_URI="http://www.xs4all.nl/~wbsoft/linux/projects/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="ssl"

DEPEND="
	>=dev-lang/tcl-8.3:0=
	>=dev-lang/tk-8.3:0="
RDEPEND="${DEPEND}
	ssl? ( dev-libs/openssl )
	"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.2a-gentoo.patch

	if use ssl; then
		sed -i "s:^USE_OPENSSL=true:USE_OPENSSL=false:g" config || die
	fi
}

src_install() {
	dobin ${PN}
	dodoc README ChangeLog TODO WARNING INSTALL
}
