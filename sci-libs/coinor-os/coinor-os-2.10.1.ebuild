# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

MY_PN=OS

DESCRIPTION="COIN-OR Optimization Services"
HOMEPAGE="https://projects.coin-or.org/OS/"
SRC_URI="http://www.coin-or.org/download/source/${MY_PN}/${MY_PN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0/6"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs test"
RESTRICT="!test? ( test )"

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

S="${WORKDIR}/${MY_PN}-${PV}/${MY_PN}"

PATCHES=( "${FILESDIR}/${PN}-2.10.1-fix-c++14.patch" )

src_prepare() {
	default

	# needed for the --with-coin-instdir
	dodir /usr
}

src_configure() {
	append-cppflags -DNDEBUG

	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		--enable-dependency-linking \
		--with-coin-instdir="${ED%/}"/usr
}

src_install() {
	default
	use doc && dodoc doc/*.pdf

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
