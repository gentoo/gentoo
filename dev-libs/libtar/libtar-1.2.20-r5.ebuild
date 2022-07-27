# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C library for manipulating tar archives"
HOMEPAGE="https://repo.or.cz/w/libtar.git/"
SRC_URI="https://dev.gentoo.org/~pinkbyte/distfiles/snapshots/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="zlib"
# There is no test and 'check' target errors out due to mixing of automake &
# non-automake makefiles.
# https://bugs.gentoo.org/526436
RESTRICT="test"

RDEPEND="
	zlib? ( sys-libs/zlib:= )
	!zlib? ( app-arch/gzip )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.11-free.patch
	"${FILESDIR}"/${PN}-1.2.11-impl-dec.patch
	"${FILESDIR}"/CVE-2013-4420.patch
	"${FILESDIR}"/${P}-fd-leaks.patch
	"${FILESDIR}"/${P}-tar_open-memleak.patch
	"${FILESDIR}"/${P}-bin-memleaks.patch
)

src_prepare() {
	default

	sed -e '/INSTALL_PROGRAM/s:-s::' \
		-i {doc,lib{,tar}}/Makefile.in || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-encap
		--disable-epkg-install
		$(use_with zlib)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	dodoc ChangeLog-1.0.x
	newdoc compat/README README.compat
	newdoc compat/TODO TODO.compat
	newdoc listhash/TODO TODO.listhash

	find "${ED}" -name '*.la' -delete || die
}
