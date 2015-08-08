# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Unconditional dependency of gcc.  Keep this set to 0.
EAPI="0"

inherit eutils libtool multilib

DESCRIPTION="A library for multiprecision complex arithmetic with exact rounding"
HOMEPAGE="http://mpc.multiprecision.org/"
SRC_URI="http://www.multiprecision.org/mpc/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

DEPEND=">=dev-libs/gmp-4.3.2
	>=dev-libs/mpfr-2.4.2"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	elibtoolize # for FreeMiNT, bug #347317
}

src_compile() {
	econf $(use_enable static-libs static) || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	use static-libs || rm "${ED:-${D}}"/usr/lib*/libmpc.la
	dodoc ChangeLog NEWS README TODO
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/libmpc.so.2
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/libmpc.so.2
}
