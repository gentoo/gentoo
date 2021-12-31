# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Communication package providing the X, Y, and ZMODEM file transfer protocols"
HOMEPAGE="https://www.ohse.de/uwe/software/lrzsz.html"
SRC_URI="https://www.ohse.de/uwe/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="nls"

DEPEND="nls? ( virtual/libintl )"

PATCHES=(
	"${FILESDIR}"/${PN}-autotools.patch
	"${FILESDIR}"/${PN}-implicit-decl.patch
	"${FILESDIR}"/${P}-automake-1.12.patch
	"${FILESDIR}"/${P}-automake-1.13.patch
	"${FILESDIR}"/${P}-gettext-0.20.patch
)

DOCS=( AUTHORS COMPATABILITY ChangeLog NEWS \
	README{,.cvs,.gettext,.isdn4linux,.tests} THANKS TODO )

src_prepare() {
	default
	# automake is unhappy if this is missing
	>> config.rpath || die
	# This is too old.  Remove it so automake puts in a newer copy.
	rm -f missing || die
	# Autoheader does not like seeing this file.
	rm -f acconfig.h || die

	eautoreconf
}

src_configure() {
	tc-export CC
	append-flags -Wstrict-prototypes
	econf $(use_enable nls)
}

src_test() {
	#Don't use check target.
	#See bug #120748 before changing this function.
	make vcheck || die "tests failed"
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
