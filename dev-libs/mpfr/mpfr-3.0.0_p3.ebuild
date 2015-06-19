# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/mpfr/mpfr-3.0.0_p3.ebuild,v 1.13 2012/06/06 03:41:44 zmedico Exp $

# NOTE: we cannot depend on autotools here starting with gcc-4.3.x
inherit eutils multilib

MY_PV=${PV/_p*}
MY_P=${PN}-${MY_PV}
PLEVEL=${PV/*p}
DESCRIPTION="library for multiple-precision floating-point computations with exact rounding"
HOMEPAGE="http://www.mpfr.org/"
SRC_URI="http://www.mpfr.org/mpfr-${MY_PV}/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/gmp-4.1.4-r2"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	[[ ${PLEVEL} == ${PV} ]] && return 0
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
	sed -i '/if test/s:==:=:' configure #261016
	find . -type f -print0 | xargs -0 touch -r configure
}

src_install() {
	emake install DESTDIR="${D}" || die
	rm "${D}"/usr/share/doc/${PN}/*.html || die
	mv "${D}"/usr/share/doc/{${PN},${PF}} || die
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
	dohtml *.html
	prepalldocs
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/libmpfr.so.1
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/libmpfr.so.1
}
