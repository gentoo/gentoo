# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="TLS OpenSSL extension to Tcl"
HOMEPAGE="http://tls.sourceforge.net/"
SRC_URI="https://core.tcl.tk/tcltls/uv/tcl${P}-src.tar.gz"

S="${WORKDIR}"/tcltls-20260121024900-5d3e3c3bf8

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="tk"

DEPEND="
	dev-lang/tcl:0=
	dev-libs/openssl:0=
	tk? ( dev-lang/tk:0= )"
RDEPEND="${DEPEND}"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${P}-cmpMan.patch
)

src_configure() {
	econf \
		--disable-hardening \
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	default
	mv "${ED}"/usr/$(get_libdir)/tcltls2.0/html \
		"${ED}"/usr/share/doc/${PF} || die
	mv "${ED}"/usr/include/{,tcl}tls.h || die
	rm "${ED}"/usr/$(get_libdir)/tcltls2.0/{README.txt,license.terms} \
		|| die

	if [[ ${CHOST} == *-darwin* ]] ; then
		# this is ugly, but fixing the makefile mess is even worse
		local loc=usr/$(get_libdir)/tls2.0/libtls2.0.dylib
		install_name_tool -id "${EPREFIX}"/${loc} "${ED}"/${loc} || die
	fi
}
