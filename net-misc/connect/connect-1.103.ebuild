# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/connect/connect-1.103.ebuild,v 1.2 2014/07/06 13:20:53 mgorny Exp $

EAPI=3

inherit toolchain-funcs

IUSE=""
DESCRIPTION="network connection relaying command (proxy)"
HOMEPAGE="https://bitbucket.org/gotoh/connect"
HG_COMMIT_ID="ee1fbc21da4b" # bitbucket commit id
#SRC_URI="https://www.bitbucket.org/gotoh/connect/get/${PV}.tar.bz2 -> ${P}.tar.bz2"
SRC_URI="http://bitbucket.org/gotoh/connect/get/${HG_COMMIT_ID}.tar.bz2 -> ${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DEPEND=""
RDEPEND=""
S="${WORKDIR}/gotoh-connect-${HG_COMMIT_ID}"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} ${PN}.c || die "compilation failed"
}

src_install() {
	dobin ${PN}
}

pkg_postinst() {
	einfo
	einfo "There is no manpage."
	einfo "Please see https://bitbucket.org/gotoh/connect/wiki/Home for details."
	einfo
}
