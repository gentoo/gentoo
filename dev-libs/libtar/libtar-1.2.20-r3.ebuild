# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtar/libtar-1.2.20-r3.ebuild,v 1.1 2015/07/21 05:36:23 idella4 Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="C library for manipulating tar archives"
HOMEPAGE="http://www.feep.net/libtar/ http://repo.or.cz/w/libtar.git/"
SRC_URI="http://dev.gentoo.org/~pinkbyte/distfiles/snapshots/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="static-libs zlib"

RDEPEND="zlib? ( sys-libs/zlib )
	!zlib? ( app-arch/gzip )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.11-free.patch
	"${FILESDIR}"/${PN}-1.2.11-impl-dec.patch
	"${FILESDIR}"/CVE-2013-4420.patch
)

src_prepare() {
	sed -i \
		-e '/INSTALL_PROGRAM/s:-s::' \
		{doc,lib{,tar}}/Makefile.in || die

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-encap
		--disable-epkg-install
		$(use_with zlib)
	)

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	dodoc ChangeLog* README TODO
	newdoc compat/README README.compat
	newdoc compat/TODO TODO.compat
	newdoc listhash/TODO TODO.listhash
}
