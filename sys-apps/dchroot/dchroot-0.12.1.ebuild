# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dchroot/dchroot-0.12.1.ebuild,v 1.4 2014/08/30 11:55:13 mgorny Exp $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="Utility for managing chroots for non-root users"
HOMEPAGE="http://packages.debian.org/unstable/admin/dchroot"
SRC_URI="mirror://debian/pool/main/d/dchroot/dchroot_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/help2man"
RDEPEND="!dev-util/schroot[dchroot]"

src_prepare() {
	sed -i \
		-e '/^all:/s:$: docs:' \
		-e '/^CFLAGS/s:-O2:@CFLAGS@:' \
		-e '/@CFLAGS@/ s:@CFLAGS@:@CFLAGS@ @LDFLAGS@:' \
		Makefile.in || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README TODO
}
