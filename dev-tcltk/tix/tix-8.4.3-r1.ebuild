# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib

MY_P="Tix${PV}"
DESCRIPTION="A widget library for Tcl/Tk"
HOMEPAGE="http://tix.sourceforge.net/"
SRC_URI="mirror://sourceforge/tix/${MY_P}-src.tar.gz"

IUSE=""
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"

RESTRICT="test"

DEPEND="
	dev-lang/tk:0=
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	(use x86-macos || use x64-macos) || epatch "${FILESDIR}"/${P}-link.patch
	sed \
		-e 's:-Os::g' \
		-i configure tclconfig/tcl.m4 || die
	epatch \
		"${FILESDIR}"/${P}-tcl8.5.patch \
		"${FILESDIR}"/${P}-tcl8.6.patch
}

src_configure() {
	econf \
		--with-tcl="${EPREFIX}/usr/$(get_libdir)" \
		--with-tk="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	default

	# Bug 168897
	doheader generic/tix.h
	# Bug 201138
	if use x86-macos || use x64-macos; then
		mv "${ED}"/usr/$(get_libdir)/${MY_P}/libTix{,.}${PV}.dylib
		dosym ${MY_P}/libTix.${PV}.dylib /usr/$(get_libdir)/libTix.${PV}.dylib
	else
		dosym ${MY_P}/lib${MY_P}.so /usr/$(get_libdir)/lib${MY_P}.so
	fi

	dodoc ChangeLog README.txt docs/*.txt
	dohtml -r index.html ABOUT.html docs/
}
