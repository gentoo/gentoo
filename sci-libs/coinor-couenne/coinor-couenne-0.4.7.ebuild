# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils multilib

MYPN=Couenne

DESCRIPTION="COIN-OR Convex Over and Under ENvelopes for Nonlinear Estimation"
HOMEPAGE="https://projects.coin-or.org/Couenne/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="sci-libs/coinor-bonmin:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

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

src_compile() {
	autotools-utils_src_compile
	# resolve as-needed
	# circular dependencies between libCouenne and libBonCouenne :(
	pushd "${BUILD_DIR}"/src > /dev/null
	rm libCouenne.la main/libBonCouenne.la || die
	emake LIBS+=" -Lmain/.libs -lBonCouenne" libCouenne.la
	emake -C main
	popd > /dev/null
}

src_install() {
	autotools-utils_src_install
	use doc && dodoc doc/couenne-user-manual.pdf
	# already installed
	rm "${ED}"/usr/share/coin/doc/${MYPN}/{README,AUTHORS,LICENSE} || die
}
