# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/itcl/itcl-4.0.3.ebuild,v 1.2 2015/03/20 10:30:35 jlec Exp $

EAPI=5

inherit eutils multilib versionator

MY_P="${PN}${PV}"
TCL_VER="8.6.2"

DESCRIPTION="Object Oriented Enhancements for Tcl/Tk"
HOMEPAGE="http://incrtcl.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/incrtcl/%5Bincr%20Tcl_Tk%5D-4-source/itcl%20${PV}/${MY_P}.tar.gz"
#SRC_URI="mirror://sourceforge/project/incrtcl/%5Bincr%20Tcl_Tk%5D-4-source/itcl%204.0.2/itcl4.0.2.tar.gz"
#SRC_URI="mirror://sourceforge/project/tcl/Tcl/${TCL_VER}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND=">=dev-lang/tcl-8.6:0="
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}${PV}"

# somehow broken
#RESTRICT=test

src_configure() {
	econf \
		--with-tcl="${EPREFIX}"/usr/$(get_libdir) \
		--with-tclinclude="${EPREFIX}"/usr/include \
		--disable-rpath
}

src_compile() {
	# adjust install_name on darwin
	if [[ ${CHOST} == *-darwin* ]]; then
		sed -i \
			-e 's:^\(SHLIB_LD\W.*\)$:\1 -install_name ${pkglibdir}/$@:' \
			"${S}"/Makefile || die 'sed failed'
	fi

	sed 's:-pipe::g' -i Makefile || die

	emake CFLAGS_DEFAULT="${CFLAGS}"
}

src_install() {
	default

	sed \
		-e "/BUILD_LIB_SPEC/s:-L${S}::g" \
		-e "/BUILD_STUB_LIB_SPEC/s:-L${S}::g" \
		-e "/BUILD_STUB_LIB_PATH/s:${S}:${EPREFIX}/usr/$(get_libdir)/${MY_P}/:g" \
		-e "/INCLUDE_SPEC/s:${S}/generic:${EPREFIX}/usr/include:g" \
		-e "s:${S}:${EPREFIX}/usr/$(get_libdir)/${MY_P}/:g" \
		-i "${ED}"/usr/$(get_libdir)/${MY_P}/itclConfig.sh || die

	cat >> "${T}"/34${PN} <<- EOF
	LDPATH="${EPREFIX}/usr/$(get_libdir)/${PN}$(get_version_component_range 1-3)/"
	EOF
	doenvd "${T}"/34${PN}
}
