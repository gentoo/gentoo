# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="TLS OpenSSL extension to Tcl"
HOMEPAGE="http://tls.sourceforge.net/"
SRC_URI="https://core.tcl-lang.org/tcltls/uv/tcl${P/-}.tar.gz"
S="${WORKDIR}"/tcl${P/-}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="tk"

DEPEND="
	dev-lang/tcl:=
	dev-libs/openssl:=
	tk? ( dev-lang/tk:= )
"
RDEPEND="${DEPEND}"
BDEPEND="dev-tcltk/tcllib"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.1-cmpMan.patch
)

src_configure() {
	econf \
		--disable-hardening \
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	default
	mv "${ED}"/usr/$(get_libdir)/tcltls${PV}/html \
		"${ED}"/usr/share/doc/${PF} || die
	mv "${ED}"/usr/include/{,tcl}tls.h || die
	rm "${ED}"/usr/$(get_libdir)/tcltls${PV}/{README.txt,license.terms} \
		|| die

	if [[ ${CHOST} == *-darwin* ]] ; then
		# this is ugly, but fixing the makefile mess is even worse
		local loc=usr/$(get_libdir)/tls${PV}/libtls${PV}.dylib
		install_name_tool -id "${EPREFIX}"/${loc} "${ED}"/${loc} || die
	fi
}
