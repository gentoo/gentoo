# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/coinor-blis/coinor-blis-0.93.10.ebuild,v 1.2 2014/02/04 09:55:14 jlec Exp $

EAPI=5

inherit autotools-utils multilib

MYPN=Blis

DESCRIPTION="COIN-OR BiCePS Linear Integer Solver"
HOMEPAGE="https://projects.coin-or.org/CHiPPS/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="CPL-1.0"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples static-libs test"

RDEPEND="
	sci-libs/coinor-utils:=
	sci-libs/coinor-bcps:=
	sci-libs/coinor-clp:=
	sci-libs/coinor-alps:="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( sci-libs/coinor-sample )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	# needed for the --with-coin-instdir
	dodir /usr
	sed -i \
		-e "s:lib/pkgconfig:$(get_libdir)/pkgconfig:g" \
		configure || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-dependency-linking
		--with-coin-instdir="${ED}"/usr
	)
	autotools-utils_src_configure
}

src_test() {
	autotools-utils_src_test test
}

src_install() {
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
