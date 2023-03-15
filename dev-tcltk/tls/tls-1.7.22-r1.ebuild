# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_P="tcl${P}"

DESCRIPTION="TLS OpenSSL extension to Tcl"
HOMEPAGE="http://tls.sourceforge.net/"
SRC_URI="https://core.tcl.tk/tcltls/uv/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="tk"

DEPEND="
	dev-lang/tcl:0=
	dev-libs/openssl:0=
	tk? ( dev-lang/tk:0= )"
RDEPEND="${DEPEND}"

RESTRICT="test"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-gcc11.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-hardening \
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
