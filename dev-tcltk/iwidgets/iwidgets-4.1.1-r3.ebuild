# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit virtualx autotools

BASE_URI_ITCLTK="mirror://sourceforge/incrtcl/%5BIncr%20Tcl_Tk%5D-4-source"

DESCRIPTION="Widget collection for incrTcl/incrTk"
HOMEPAGE="http://incrtcl.sourceforge.net/itcl/"
SRC_URI="mirror://sourceforge/incrtcl/%5BIncr%20Widgets%5D/${PV}/${P}.tar.gz"

LICENSE="HPND Old-MIT tcltk"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-tcltk/itcl-4.2.4-r1
	>=dev-tcltk/itk-4.1.0-r1"
RDEPEND="${DEPEND}"

QA_CONFIG_IMPL_DECL_SKIP=(
	stat64 # used to test for Large File Support
)

PATCHES=( "${FILESDIR}"/${P}-dash.patch )

src_prepare() {
	default
	sed \
		-e "/^\(LIB\|SCRIPT\)_INSTALL_DIR =/s|lib|$(get_libdir)|" \
		-i Makefile.in || die

	eautoreconf

	# Bug 115470
	rm doc/panedwindow.n

	rm tests/hierarchy.test || die
}

src_configure() {
	local itcl_package=$(best_version dev-tcltk/itcl)
	local itcl_version=${itcl_package#*/*-}
	local itcl="itcl${itcl_version%-*}"
	local itk_package=$(best_version dev-tcltk/itk)
	local itk_version=${itk_package#*/*-}
	local itk="itk${itk_version%-*}"
	econf \
		--with-tcl="${EPREFIX}"/usr/$(get_libdir) \
		--with-tk="${EPREFIX}"/usr/$(get_libdir) \
		--with-itcl="${EPREFIX}"/usr/$(get_libdir)/${itcl} \
		--with-itk="${EPREFIX}"/usr/$(get_libdir)/${itk}
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
