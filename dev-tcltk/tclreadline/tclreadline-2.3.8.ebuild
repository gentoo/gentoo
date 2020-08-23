# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Readline extension to TCL"
HOMEPAGE="https://github.com/flightaware/tclreadline"
SRC_URI="https://github.com/flightaware/tclreadline/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="tk"

DEPEND="dev-lang/tcl:0=
	sys-libs/readline:0=
	tk? ( dev-lang/tk:0= )"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local myConf=--with-tcl="${EPREFIX}/usr/$(get_libdir)"
	if ! use tk; then
		myConf="$myConf --without-tk"
	fi
	econf $myConf
}

src_install() {
	default
	find "${D}" -name \*.la -delete
}
