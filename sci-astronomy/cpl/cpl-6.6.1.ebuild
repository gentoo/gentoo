# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_OPT_USE=gasgano

inherit autotools java-pkg-opt-2

DESCRIPTION="ESO common pipeline library for astronomical data reduction"
HOMEPAGE="http://www.eso.org/sci/software/cpl/"
SRC_URI="ftp://ftp.eso.org/pub/dfs/pipelines/libraries/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/20"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="doc gasgano static-libs threads"

RDEPEND="
	sci-astronomy/wcslib:0=
	sci-libs/cfitsio:0=
	sci-libs/fftw:3.0=
	gasgano? ( sci-astronomy/gasgano )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-6.6.1-use-system-ltdl.patch
)

src_prepare() {
	default
	# remove cpu chcking
	sed -e '/CPL_CHECK_CPU/d' \
		-i configure.ac libcext/configure.ac || die
	# search for shared libs, not static
	sed -e 's/\.a/\.so/g' \
		-i m4/cpl.m4 || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
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
	prune_libtool_files --all
	use doc && emake install-html
}
