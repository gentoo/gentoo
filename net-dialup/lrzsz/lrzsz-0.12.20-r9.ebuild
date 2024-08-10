# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Communication package providing the X, Y, and ZMODEM file transfer protocols"
HOMEPAGE="https://www.ohse.de/uwe/software/lrzsz.html"
SRC_URI="
	https://www.ohse.de/uwe/releases/${P}.tar.gz
	https://dev.gentoo.org/~ceamac/${CATEGORY}/${PN}/${PN}-m4-${PV}.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="nls"

DEPEND="nls? ( virtual/libintl )"
BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-autotools.patch
	"${FILESDIR}"/${PN}-implicit-decl.patch
	"${FILESDIR}"/${P}-automake-1.12.patch
	"${FILESDIR}"/${P}-automake-1.13.patch
	"${FILESDIR}"/${P}-gettext-0.20.patch
	"${FILESDIR}"/${P}-AR.patch
	"${FILESDIR}"/${P}-configure-clang16.patch
	"${FILESDIR}"/${P}-gettext-0.22.patch
	"${FILESDIR}"/${P}-disable-nls.patch
	"${FILESDIR}"/${P}-c99.patch
	"${FILESDIR}"/${P}-fix-integer-overflow.patch
)

DOCS=( AUTHORS COMPATABILITY ChangeLog NEWS \
	README{,.cvs,.gettext,.isdn4linux,.tests} THANKS TODO )

src_prepare() {
	default

	# automake is unhappy if this is missing
	>> config.rpath || die
	# This is too old.  Remove it so automake puts in a newer copy.
	rm missing || die
	# Autoheader does not like seeing this file.
	rm acconfig.h || die
	# embed default m4 files in case gettext is not installed
	mv "${WORKDIR}"/m4 . || die

	eautoreconf
}

src_configure() {
	tc-export CC

	econf $(use_enable nls)
}

src_test() {
	# Don't use check target.
	# See bug #120748 before changing this function.
	emake vcheck
}

src_install() {
	default

	local x
	for x in {r,s}{b,x,z} ; do
		dosym l${x} /usr/bin/${x}
		dosym l${x:0:1}z.1 /usr/share/man/man1/${x}.1
		[ "${x:1:1}" = "z" ] || dosym l${x:0:1}z.1 /usr/share/man/man1/l${x}.1
	done
}
