# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mepl/mepl-0.45.ebuild,v 1.13 2012/10/29 08:39:25 ago Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Self-employed-mode software for 3COM/USR message modems"
HOMEPAGE="http://www.hof-berlin.de/mepl/"
SRC_URI="http://www.hof-berlin.de/mepl/mepl${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/${PN}${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/gcc433.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -DMEPLCONFIG=\\\"/etc/mepl.conf\\\"\
	${LDFLAGS}" en || die
}

src_install() {
	dobin mepl meplmail || die
	insinto /etc
	doins mepl.conf
	newman mepl.en mepl.7
}
