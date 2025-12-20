# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_OPT_USE=gasgano

inherit autotools java-pkg-opt-2

DESCRIPTION="ESO common pipeline library for astronomical data reduction"
HOMEPAGE="https://www.eso.org/sci/software/cpl/"
SRC_URI="https://ftp.eso.org/pub/dfs/pipelines/libraries/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/26"
KEYWORDS="~amd64 ~x86"

IUSE="doc gasgano static-libs threads"

RDEPEND="
	dev-libs/libltdl
	sci-astronomy/wcslib:0=
	sci-libs/cfitsio:0=
	sci-libs/fftw:3.0=
	gasgano? ( sci-astronomy/gasgano )"
DEPEND="${RDEPEND}
	doc? ( app-text/doxygen )"

src_prepare() {
	default
	# remove cpu chcking
	sed -e '/CPL_CHECK_CPU/d' \
		-i configure.ac libcext/configure.ac || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-ltdl-install
		--without-included-ltdl
		--with-cfitsio="${EPREFIX}/usr"
		--with-wcs="${EPREFIX}/usr"
		--with-fftw="${EPREFIX}/usr"
		$(use_enable doc maintainer-mode)
		$(use_enable static-libs static)
		$(use_enable threads)
	)
	if use gasgano; then
		myeconfargs+=(
			--enable-gasgano
			--with-gasgano="${EPREFIX}/usr"
			--with-gasgano-classpath="${EPREFIX}/usr/share/gasgano/lib"
			--with-java="$(java-config -O)"
		)
	else
		myeconfargs+=( --disable-gasgano )
	fi
	econf ${myeconfargs[@]}
}

src_compile() {
	default
	use doc && emake html
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	use doc && emake install-html
}
