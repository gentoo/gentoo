# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit virtualx multilib

BASE_URI_ITCLTK="mirror://sourceforge/incrtcl/%5BIncr%20Tcl_Tk%5D-4-source"
ITCL_VER=4.1.1
ITK_VER=4.1.0

DESCRIPTION="Widget collection for incrTcl/incrTk"
HOMEPAGE="http://incrtcl.sourceforge.net/itcl/"
SRC_URI="
	mirror://sourceforge/incrtcl/%5BIncr%20Widgets%5D/${PV}/${P}.tar.gz
	${BASE_URI_ITCLTK}/itcl%20${ITCL_VER}/itcl${ITCL_VER}.tar.gz
	${BASE_URI_ITCLTK}/itk%20${ITK_VER}/itk${ITK_VER}.tar.gz"

LICENSE="HPND Old-MIT tcltk"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	>=dev-tcltk/itcl-${ITCL_VER}
	>=dev-tcltk/itk-${ITK_VER}"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed \
		-e "/^\(LIB\|SCRIPT\)_INSTALL_DIR =/s|lib|$(get_libdir)|" \
		-i Makefile.in || die

	# Bug 115470
	rm doc/panedwindow.n

	rm tests/hierarchy.test || die
}

src_configure() {
	(cd ../itcl${ITCL_VER}; ./configure)
	econf \
		--with-tcl="${EPREFIX}"/usr/$(get_libdir) \
		--with-tk="${EPREFIX}"/usr/$(get_libdir) \
		--with-itcl="${WORKDIR}"/itcl${ITCL_VER} \
		--with-itk="${WORKDIR}"/itk${ITK_VER}
}

src_compile() {
	:
}

src_test() {
	virtx default
}

src_install() {
	default

	# demos are in the wrong place:
	mv "${ED}/usr/$(get_libdir)/${PN}${PV}/demos" "${ED}/usr/share/doc/${PF}/"
}
