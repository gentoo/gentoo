# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# this ebuild is only for the libmpfr.so.1 ABI SONAME

EAPI="5"

inherit eutils libtool multilib multilib-minimal flag-o-matic

MY_PV=${PV/_p*}
MY_P=${PN}-${MY_PV}
DESCRIPTION="library for multiple-precision floating-point computations with exact rounding"
HOMEPAGE="http://www.mpfr.org/"
SRC_URI="http://www.mpfr.org/mpfr-${MY_PV}/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~ppc-aix ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=dev-libs/gmp-4.1.4-r2:0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${MY_PV}/patch*
	sed -i '/if test/s:==:=:' configure #261016
	find . -type f -exec touch -r configure {} +
	elibtoolize
}

multilib_src_configure() {
	# Newer gmp has deleted this define, so export it for older mpfr.
	append-cppflags -D__gmp_const=const
	# Make sure mpfr doesn't go probing toolchains it shouldn't #476336#19
	ECONF_SOURCE=${S} \
	user_redefine_cc=yes \
	econf --disable-static
}

multilib_src_compile() {
	emake libmpfr.la
}

multilib_src_install() {
	emake DESTDIR="${D}" install-libLTLIBRARIES
	rm -f "${ED}"/usr/*/libmpfr.{la,so,dylib,a}
}
