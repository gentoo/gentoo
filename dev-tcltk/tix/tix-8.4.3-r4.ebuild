# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="Tix${PV}"
DESCRIPTION="A widget library for Tcl/Tk"
HOMEPAGE="http://tix.sourceforge.net/"
SRC_URI="mirror://sourceforge/tix/${MY_P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
RESTRICT="test"

DEPEND="
	dev-lang/tk:=
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-tcl8.5.patch
	"${FILESDIR}"/${P}-tcl8.6.patch
	"${FILESDIR}"/${P}-wimplicit-int.patch
	"${FILESDIR}"/${P}-clang6.patch
	"${FILESDIR}"/${P}-noopt.patch
)

QA_CONFIG_IMPL_DECL_SKIP=(
	stat64 # used to test for Large File Support
)

src_prepare() {
	[[ ${CHOST} == *-darwin* ]] || eapply "${FILESDIR}"/${P}-link.patch

	sed \
		-e 's:-Os::g' \
		-i configure tclconfig/tcl.m4 || die
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-tcl="${EPREFIX}/usr/$(get_libdir)" \
		--with-tk="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	DOCS=( ChangeLog README.txt docs/*.txt )
	HTML_DOCS=(
		index.html
		ABOUT.html
		docs/*.html
		docs/html
		docs/img
		docs/tix-book
	)

	default

	# Bug #168897
	doheader generic/tix.h

	# Bug #201138
	if [[ ${CHOST} == *-darwin* ]] ; then
		mv "${ED}"/usr/$(get_libdir)/${MY_P}/libTix{,.}${PV}.dylib || die
		dosym ${MY_P}/libTix.${PV}.dylib /usr/$(get_libdir)/libTix.${PV}.dylib
	else
		dosym ${MY_P}/lib${MY_P}.so /usr/$(get_libdir)/lib${MY_P}.so
	fi
}
