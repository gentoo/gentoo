# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit virtualx

MY_PV=${PN}-$(ver_rs 1- '-')
TCLCONFIGId=4a924db4fb37fa0c7cc2ae987b294dbaa97bc713

DESCRIPTION="Object Oriented Enhancements for Tcl/Tk"
HOMEPAGE="http://incrtcl.sourceforge.net/"
SRC_URI="
	https://github.com/tcltk/${PN}/archive/refs/tags/${MY_PV}.tar.gz
	https://github.com/tcltk/tclconfig/archive/${TCLCONFIGId}.tar.gz
		-> tclconfig-2023.12.11.tar.gz
"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm64 ~ppc ~riscv sparc ~x86 ~amd64-linux ~x86-linux"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-lang/tk-8.6:=
	>=dev-tcltk/itcl-4.1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

QA_CONFIG_IMPL_DECL_SKIP=(
	opendir64 readdir64 rewinddir64 closedir64 stat64 # used on AIX
)

UNINSTALL_IGNORE='/usr/lib.*/itk.*/library'

src_prepare() {
	ln -s ../tclconfig-${TCLCONFIGId} tclconfig || die
	sed 's:-pipe::g' -i configure || die
	default
	echo "unknown" > manifest.uuid
}

src_configure() {
	local itcl_package=$(best_version dev-tcltk/itcl)
	local itcl_version=${itcl_package#*/*-}
	local ITCL_VERSION="${itcl_version%-*}"
	source "${EPREFIX}"/usr/$(get_libdir)/itcl${ITCL_VERSION}*/itclConfig.sh || die
	econf \
		--with-tcl="${EPREFIX}"/usr/$(get_libdir) \
		--with-tclinclude="${EPREFIX}"/usr/include \
		--with-tk="${EPREFIX}"/usr/$(get_libdir) \
		--with-tkinclude="${EPREFIX}"/usr/include \
		--with-itcl="${ITCL_SRC_DIR}" \
		--with-x
}

src_compile() {
	emake CFLAGS_DEFAULT="${CFLAGS}"
}

src_test() {
	virtx default
}

src_install() {
	default

	dodoc license.terms

	cat >> "${T}"/34${PN} <<- EOF
	LDPATH="${EPREFIX}/usr/$(get_libdir)/${PN}${MY_PV}/"
	EOF
	doenvd "${T}"/34${PN}
	dosym . /usr/$(get_libdir)/${PN}${PV}/library
}
