# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN=CoinUtils

DESCRIPTION="COIN-OR Matrix, Vector and other utility classes"
HOMEPAGE="https://github.com/coin-or/CoinUtils/"
SRC_URI="https://github.com/coin-or/${MY_PN}/archive/releases/${PV}.tar.gz
	-> ${P}.tar.gz"
LICENSE="EPL-1.0"

# major soname component
SLOT="0/3"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 doc glpk blas lapack static-libs test zlib"
RESTRICT="!test? ( test )"

# Fortran is NOT needed, but the ./configure scripts for all of the CoinOR
# packages contain a check for it. Gentoo bug 601648 and upstream issue,
#
#   https://github.com/coin-or/CoinUtils/issues/132
#
BDEPEND="virtual/fortran
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-libs/coinor-sample )"
DEPEND="sys-libs/readline:0=
	blas? ( virtual/blas )
	bzip2? ( app-arch/bzip2 )
	glpk? ( sci-mathematics/glpk:= )
	lapack? ( virtual/lapack )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-releases-${PV}/${MY_PN}"

src_prepare() {
	# Needed to make the --with-coin-instdir in src_configure happy.
	dodir /usr

	# They don't need to guess at this, but they do, and get it wrong...
	sed -e "s:lib/pkgconfig:$(get_libdir)/pkgconfig:g" \
		-i configure \
		|| die "failed to fix the pkgconfig path in ${S}/configure"

	default
}

src_configure() {
	local myeconfargs=(
		--enable-dependency-linking
		--with-coin-instdir="${ED}/usr"
		$(use_enable zlib)
		$(use_enable bzip2 bzlib)
		$(use_with doc dot)
	)
	if use blas; then
		myeconfargs+=( --with-blas-lib="$($(tc-getPKG_CONFIG) --libs blas)" )
	else
		myeconfargs+=( --without-blas )
	fi
	if use glpk; then
		myeconfargs+=(
			--with-glpk-incdir="${EPREFIX}"/usr/include
			--with-glpk-lib=-lglpk
		)
	else
		myeconfargs+=( --without-glpk )
	fi
	if use lapack; then
		myeconfargs+=( --with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)" )
	else
		myeconfargs+=( --without-lapack )
	fi

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake all $(usex doc doxydoc "")
}

src_test() {
	# NOT redundant! The build system has a "make check" target that does
	# nothing, so if you don't specify "test" here, you'll get a no-op.
	emake test
}

src_install() {
	use doc && HTML_DOC=("${BUILD_DIR}/doxydocs/html/")

	emake DESTDIR="${D}" install

	# Duplicate junk, and in the wrong location.
	rm -r "${ED}/usr/share/coin/doc/${MY_PN}" || die
}
