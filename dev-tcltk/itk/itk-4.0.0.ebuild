# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils multilib versionator

MY_PV=${PV/_beta/b}
ITCL_VERSION="$(get_version_component_range 1-2)"

DESCRIPTION="Object Oriented Enhancements for Tcl/Tk"
HOMEPAGE="http://incrtcl.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/incrtcl/%5Bincr%20Tcl_Tk%5D-4-source/Itcl%20${MY_PV}/${PN}${MY_PV}.tar.gz"
#SRC_URI="mirror://sourceforge/%5Bincr%20Tcl_Tk%5D-4-source/Itcl%20${MY_PV}/${PN}${MY_PV}.tar.gz"

IUSE=""
SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-lang/tk-8.6:=
	=dev-tcltk/itcl-${ITCL_VERSION}*"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${MY_PV}"

src_prepare() {
#	epatch "${FILESDIR}"/${P}-install_data.patch
	AT_M4DIR=.. eautoconf
	sed 's:-pipe::g' -i configure || die
}

src_configure() {
	source "${EPREFIX}"/usr/$(get_libdir)/itcl${ITCL_VERSION}*/itclConfig.sh || die
	econf \
		--with-tcl="${EPREFIX}"/usr/$(get_libdir) \
		--with-tk="${EPREFIX}"/usr/$(get_libdir) \
		--with-tclinclude="${EPREFIX}"/usr/include \
		--with-tkinclude="${EPREFIX}"/usr/include \
		--with-itcl="${ITCL_SRC_DIR}" \
		--with-x
}

src_compile() {
	emake CFLAGS_DEFAULT="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc license.terms

	cat >> "${T}"/34${PN} <<- EOF
	LDPATH="${EPREFIX}/usr/$(get_libdir)/${PN}${MY_PV}/"
	EOF
	doenvd "${T}"/34${PN}
}
