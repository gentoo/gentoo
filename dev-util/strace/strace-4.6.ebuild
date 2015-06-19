# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/strace/strace-4.6.ebuild,v 1.9 2012/02/14 06:12:19 vapier Exp $

EAPI="3"

inherit flag-o-matic eutils autotools

DESCRIPTION="A useful diagnostic, instructional, and debugging tool"
HOMEPAGE="http://sourceforge.net/projects/strace/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz
	mirror://gentoo/${P}-x32.patch.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="static aio"

# strace only uses the header from libaio
DEPEND="aio? ( >=dev-libs/libaio-0.3.106 )
	sys-kernel/linux-headers"
RDEPEND=""

src_prepare() {
	if has x32 $(get_all_abis) ; then
		epatch "${WORKDIR}"/${P}-x32.patch
		eautoreconf
	fi
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
