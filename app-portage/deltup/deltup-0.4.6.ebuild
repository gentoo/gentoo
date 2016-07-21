# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Delta-Update - patch system for updating source-archives."
HOMEPAGE="http://deltup.sourceforge.net"
SRC_URI="https://github.com/jjwhitney/Deltup/archive/v${PV}.tar.gz -> ${P}.tar.gz"

MY_PN="Deltup"
S="${WORKDIR}/${MY_PN}-${PV}/src"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-libs/openssl:0
	sys-libs/zlib
	app-arch/bzip2"
RDEPEND="${DEPEND}
	|| ( dev-util/bdelta =dev-util/xdelta-1* )"

src_prepare () {
	default
	epatch_user
}

src_compile () {
	emake CC=$(tc-getCXX)
}

src_install () {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc "${S}"/../{README,ChangeLog}
	doman "${S}"/../deltup.1
}
