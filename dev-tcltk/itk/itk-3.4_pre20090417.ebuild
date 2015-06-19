# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/itk/itk-3.4_pre20090417.ebuild,v 1.12 2012/10/07 17:49:27 jlec Exp $

EAPI=3

inherit multilib versionator

MY_PN="incrTcl"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Object Oriented Enhancements for Tcl/Tk"
HOMEPAGE="http://incrtcl.sourceforge.net/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

IUSE=""
SLOT="0"
LICENSE="BSD"
KEYWORDS="alpha amd64 ia64 ppc sparc x86 ~amd64-linux ~x86-linux"

DEPEND="
	dev-lang/tk
	=dev-tcltk/itcl-3.4*"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}/${PN}"

src_compile() {
	sed 's:-pipe::g' -i Makefile || die
	emake CFLAGS_DEFAULT="${CFLAGS}" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc ../{CHANGES,ChangeLog,INCOMPATIBLE,README,TODO}

	cat >> "${T}"/34${PN} <<- EOF
	LDPATH="${EPREFIX}/usr/$(get_libdir)/${PN}$(get_version_component_range 1-2)/"
	EOF
	doenvd "${T}"/34${PN} || die
}
