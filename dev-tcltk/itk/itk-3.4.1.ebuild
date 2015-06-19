# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/itk/itk-3.4.1.ebuild,v 1.6 2015/04/28 09:49:24 ago Exp $

EAPI=5

inherit autotools eutils multilib versionator virtualx

MY_PV=${PV/_beta/b}
ITCL_VERSION="$(get_version_component_range 1-2)"

DESCRIPTION="Object Oriented Enhancements for Tcl/Tk"
HOMEPAGE="http://incrtcl.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/incrtcl/%5BIncr%20Tcl_Tk%5D-source/${PV}/${PN}${PV}.tar.gz"

IUSE=""
SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha amd64 ia64 ppc sparc x86 ~amd64-linux ~x86-linux"

DEPEND="
	<dev-lang/tk-8.6
	=dev-tcltk/itcl-3.4*"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}$(get_version_component_range 1-2)"

src_prepare() {
	#epatch "${FILESDIR}"/${P}-install_data.patch
	mv configure.{in,ac} || die
	AT_M4DIR=.. eautoconf
	sed 's:-pipe::g' -i configure || die
}

src_configure() {
	source "${EPREFIX}"/usr/$(get_libdir)/itclConfig.sh || die
	econf \
		--with-tcl="${EPREFIX}"/usr/$(get_libdir) \
		--with-tk="${EPREFIX}"/usr/$(get_libdir) \
		--with-tclinclude="${EPREFIX}"/usr/include \
		--with-tkinclude="${EPREFIX}"/usr/include \
		--with-x
}

src_compile() {
	emake CFLAGS_DEFAULT="${CFLAGS}"
}

src_test() {
	Xemake test
}

src_install() {
	default

	cat >> "${T}"/34${PN} <<- EOF
	LDPATH="${EPREFIX}/usr/$(get_libdir)/${PN}${MY_PV}/"
	EOF
	doenvd "${T}"/34${PN}
}
