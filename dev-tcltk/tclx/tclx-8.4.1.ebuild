# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tclx/tclx-8.4.1.ebuild,v 1.5 2015/03/20 10:52:48 jlec Exp $

EAPI=5

inherit eutils multilib versionator

DESCRIPTION="A set of extensions to TCL"
HOMEPAGE="http://tclx.sourceforge.net"
SRC_URI="mirror://sourceforge/tclx/${PN}${PV}.tar.bz2"

LICENSE="BSD"
IUSE="tk threads"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~x86-macos"

DEPEND="
	dev-lang/tcl:0=
	tk? ( dev-lang/tk:0= )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}$(get_version_component_range 1-2)

# tests broken, bug #279283
RESTRICT="test"

src_prepare() {
	sed \
		-e '/CC=/s:-pipe::g' \
		-i tclconfig/tcl.m4 configure || die
	epatch \
		"${FILESDIR}"/${PN}-8.4-varinit.patch \
		"${FILESDIR}"/${PN}-8.4-ldflags.patch
}

src_configure() {
	econf \
		$(use_enable tk) \
		$(use_enable threads) \
		--enable-shared \
		--with-tcl="${EPREFIX}/usr/$(get_libdir)/"

	# adjust install_name on darwin
	if [[ ${CHOST} == *-darwin* ]]; then
		sed -i \
			-e 's:^\(SHLIB_LD\W.*\)$:\1 -install_name ${pkglibdir}/$@:' \
				"${S}"/Makefile || die 'sed failed'
	fi
}

src_install() {
	default
	doman doc/*.[n3]
}
