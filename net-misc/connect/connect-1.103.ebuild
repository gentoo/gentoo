# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

IUSE=""
DESCRIPTION="network connection relaying command (proxy)"
HOMEPAGE="https://bitbucket.org/gotoh/connect"
HG_COMMIT_ID="ee1fbc21da4b" # bitbucket commit id
#SRC_URI="https://www.bitbucket.org/gotoh/connect/get/${PV}.tar.bz2 -> ${P}.tar.bz2"
SRC_URI="https://bitbucket.org/gotoh/connect/get/${HG_COMMIT_ID}.tar.bz2 -> ${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
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
