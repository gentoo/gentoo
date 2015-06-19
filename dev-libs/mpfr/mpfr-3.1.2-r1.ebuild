# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/mpfr/mpfr-3.1.2-r1.ebuild,v 1.14 2014/01/18 04:34:25 vapier Exp $

EAPI="3"

# NOTE: we cannot depend on autotools here starting with gcc-4.3.x
inherit eutils libtool multilib

MY_PV=${PV/_p*}
MY_P=${PN}-${MY_PV}
PLEVEL=${PV/*p}
DESCRIPTION="library for multiple-precision floating-point computations with exact rounding"
HOMEPAGE="http://www.mpfr.org/"
SRC_URI="http://www.mpfr.org/mpfr-${MY_PV}/${MY_P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND=">=dev-libs/gmp-4.1.4-r2[static-libs?]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	if [[ ${PLEVEL} != ${PV} ]] ; then
		for ((i=1; i<=PLEVEL; ++i)) ; do
			patch=patch$(printf '%02d' ${i})
			if [[ -f ${FILESDIR}/${MY_PV}/${patch} ]] ; then
				epatch "${FILESDIR}"/${MY_PV}/${patch}
			elif [[ -f ${DISTDIR}/${PN}-${MY_PV}_p${i} ]] ; then
				epatch "${DISTDIR}"/${PN}-${MY_PV}_p${i}
			else
				ewarn "${DISTDIR}/${PN}-${MY_PV}_p${i}"
				die "patch ${i} missing - please report to bugs.gentoo.org"
			fi
		done
	fi
	sed -i '/if test/s:==:=:' configure #261016
	find . -type f -exec touch -r configure {} +
	elibtoolize
}

src_configure() {
	# Make sure mpfr doesn't go probing toolchains it shouldn't #476336#19
	user_redefine_cc=yes \
	econf \
		--docdir="\$(datarootdir)/doc/${PF}" \
		$(use_enable static-libs static)
}

src_install() {
	emake install DESTDIR="${D}" || die
	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/libmpfr.la

	# clean up html/license install
	pushd "${ED}"/usr/share/doc/${PF} >/dev/null
	dohtml *.html && rm COPYING* *.html || die
	popd >/dev/null
	# some, but not all, are already installed
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
	prepalldocs
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/libmpfr$(get_libname 1)
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/libmpfr$(get_libname 1)
}
