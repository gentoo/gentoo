# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="A yacc-compatible parser generator"
HOMEPAGE="http://www.gnu.org/software/bison/bison.html"
SRC_URI="ftp://alpha.gnu.org/pub/gnu/bison/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="nls static"

DEPEND="sys-devel/m4
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.32-extfix.patch
}

src_compile() {
	# Bug 39842 says that bison segfaults when built on amd64 with
	# optimizations.  This will probably be fixed in a future gcc
	# version, but for the moment just disable optimizations for that
	# arch (04 Feb 2004 agriffis)
	[ "$ARCH" == "amd64" ] && append-flags -O0

	# Bug 29017 says that bison has compile-time issues with
	# -march=k6* prior to 3.4CVS.  Use -march=i586 instead
	# (04 Feb 2004 agriffis)
	#
	if (( $(gcc-major-version) == 3 && $(gcc-minor-version) < 4 )) ; then
		replace-cpu-flags k6 k6-1 k6-2 i586
	fi

	econf $(use_enable nls) || die
	use static && append-ldflags -static
	emake || die
}

src_install() {
	make DESTDIR="${D}" \
		datadir=/usr/share \
		mandir=/usr/share/man \
		infodir=/usr/share/info \
		install || die

	# This one is installed by dev-util/yacc
	mv "${D}"/usr/bin/yacc "${D}"/usr/bin/yacc.bison || die

	# We do not need this.
	rm -f "${D}"/usr/lib/liby.a

	dodoc AUTHORS NEWS ChangeLog README REFERENCES OChangeLog doc/FAQ
}

pkg_postinst() {
	if [[ ! -e ${ROOT}/usr/bin/yacc ]] ; then
		ln -s yacc.bison "${ROOT}"/usr/bin/yacc
	fi
}
