# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

MY_P="tcl${PN}-${PV}"

DESCRIPTION="TLS OpenSSL extension to Tcl"
HOMEPAGE="http://tls.sourceforge.net/"
SRC_URI="https://core.tcl.tk/tcltls/uv/tcl${PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="tk"

DEPEND="
	dev-lang/tcl:0=
	dev-libs/openssl:0=
	tk? ( dev-lang/tk:0= )"
RDEPEND="${DEPEND}"

RESTRICT="test"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--with-ssl-dir="${EPREFIX}/usr" \
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	default
	dodoc tls.htm

	if [[ ${CHOST} == *-darwin* ]] ; then
		# this is ugly, but fixing the makefile mess is even worse
		local loc=usr/$(get_libdir)/tls1.7/libtls1.7.dylib
		install_name_tool -id "${EPREFIX}"/${loc} "${ED}"/${loc} || die
	fi
}
