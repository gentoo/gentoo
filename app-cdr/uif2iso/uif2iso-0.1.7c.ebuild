# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/uif2iso/uif2iso-0.1.7c.ebuild,v 1.3 2011/11/17 18:47:32 phajdan.jr Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Converts MagicISO CD-images to iso"
HOMEPAGE="http://aluigi.org/mytoolz.htm#uif2iso"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/src"

src_compile() {
	# Yes we use our own makefile, I'll try to explain this to
	# upstream _again_.
	emake CC="$(tc-getCC)" -f "${FILESDIR}/0.1.7-Makefile" || die "emake failed"
}

src_install() {
	dobin ${PN} || die "failed to install"

	dodoc "${WORKDIR}"/${PN}.txt "${WORKDIR}"/README
}
