# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils multilib flag-o-matic

MYPN=OS

DESCRIPTION="COIN-OR Optimization Services"
HOMEPAGE="https://projects.coin-or.org/OS/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0/6"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs test"

RDEPEND="
	sci-libs/coinor-bcp:=
	sci-libs/coinor-bonmin:=
	sci-libs/coinor-couenne:=
	sci-libs/coinor-clp:=
	sci-libs/coinor-dylp:=
	sci-libs/coinor-symphony:=
	sci-libs/coinor-utils:=
	sci-libs/coinor-vol:=
	sci-libs/ipopt:="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-libs/coinor-sample )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	append-cppflags -DNDEBUG
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
	use doc && dodoc doc/*.pdf
}
