# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Readline extension to TCL"
HOMEPAGE="https://github.com/flightaware/tclreadline"
SRC_URI="https://github.com/flightaware/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="tk"

DEPEND="
	dev-lang/tcl:=
	sys-libs/readline:=
	tk? ( dev-lang/tk:= )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# Needed for Clang 16 patch, can drop once in a release
	eautoreconf

	sed -i \
		-e "s|^\(TCLRL_LIBDIR\)=.*|\1=\"${EPREFIX}/usr/$(get_libdir)\"|" \
		configure || die
}

src_configure() {
	local myConf=(
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
		--with-readline-includes="${EPREFIX}/usr/include/readline"
	)
	if ! use tk; then
		myConf+=(--without-tk)
	fi
	econf "${myConf[@]}"
}

src_install() {
	default
	find "${ED}" -name \*.la -delete
}
