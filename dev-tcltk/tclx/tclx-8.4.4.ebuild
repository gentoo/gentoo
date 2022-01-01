# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="A set of extensions to TCL"
HOMEPAGE="http://tclx.sourceforge.net"
SRC_URI="https://github.com/flightaware/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
IUSE="threads"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"

DEPEND="dev-lang/tcl:0="
RDEPEND="${DEPEND}"

# tests broken, bug #279283
RESTRICT="test"

PATCHES=(
		"${FILESDIR}"/${PN}-8.4-varinit.patch
		"${FILESDIR}"/${PN}-8.4-ldflags.patch
)

src_prepare() {
	sed \
		-e '/CC=/s:-pipe::g' \
		-i tclconfig/tcl.m4 configure || die
	default
}

src_configure() {
	econf \
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
