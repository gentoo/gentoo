# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="FTP mirror utility"
HOMEPAGE="http://linux.maruhn.com/sec/fmirror.html"
SRC_URI="http://www.ibiblio.org/pub/solaris/freeware/SOURCES/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND=""
DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-crlf.patch
}

src_compile() {
	append-flags "-D_FILE_OFFSET_BITS=64" # large file support bug # 123964

	econf \
		--datadir=/etc/fmirror || die "econf failed"

	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin fmirror
	dodoc ChangeLog README
	newdoc configs/README README.sample
	doman fmirror.1

	cd configs
	insinto /etc/fmirror/sample
	doins {sample,generic,redhat}.conf
}
