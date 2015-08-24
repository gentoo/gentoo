# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit flag-o-matic eutils

DESCRIPTION="A useful diagnostic, instructional, and debugging tool"
HOMEPAGE="http://sourceforge.net/projects/strace/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	https://dev.gentoo.org/~flameeyes/patches/${PN}/${P}-ioctls.patch.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="static aio"

# strace only uses the header from libaio
DEPEND="aio? ( >=dev-libs/libaio-0.3.106 )
	sys-kernel/linux-headers"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-sparc.patch #336939
	epatch "${WORKDIR}"/${P}-ioctls.patch
}

src_configure() {
	filter-lfs-flags # configure handles this sanely
	use static && append-ldflags -static

	use aio || export ac_cv_header_libaio_h=no

	econf
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc ChangeLog CREDITS NEWS PORTING README* TODO
}
