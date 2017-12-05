# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="C library for manipulating tar archives"
HOMEPAGE="http://www.feep.net/libtar/ http://repo.or.cz/w/libtar.git/"
SRC_URI="https://dev.gentoo.org/~pinkbyte/distfiles/snapshots/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="static-libs zlib"

RDEPEND="zlib? ( sys-libs/zlib )
	!zlib? ( app-arch/gzip )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

# There is no test and 'check' target errors out due to mixing of automake &
# non-automake makefiles.
# https://bugs.gentoo.org/show_bug.cgi?id=526436
RESTRICT="test"

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
